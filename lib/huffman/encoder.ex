defmodule Huffman.Encoder do
  alias Huffman.{Tree, Leaf, Node}
  import Huffman.Utils, only: [bytes: 1]

  @spec encode(String.t()) :: {binary(), map()}
  def encode(text) do
    huffman_tree = Tree.build(text)

    # generate a codebook from the Huffman tree, mapping
    # each used character to its binary path in the tree.
    codebook = to_codebook(huffman_tree)

    # re-encode the same text based on the codebook
    encoded = to_binary(text, codebook)

    # return compressed representation and codebook
    {:ok, encoded, huffman_tree}
  end

  defp to_codebook(node, steps \\ [], book \\ %{})

  defp to_codebook(%Node{left: left, right: right}, steps, book) do
    book = to_codebook(left, steps ++ [0], book)
    to_codebook(right, steps ++ [1], book)
  end

  defp to_codebook(%Leaf{val: val}, steps, map) do
    Map.put(map, val, code_to_binary(steps))
  end

  defp code_to_binary(code) do
    code
    |> Enum.reduce(<<>>, fn part, binary ->
      <<
        binary::bitstring,
        <<part::1>>::bitstring
      >>
    end)
  end

  defp to_binary(text, codebook) do
    text
    |> bytes()
    |> Enum.reduce(<<>>, fn char, list ->
      char_as_binary = Map.get(codebook, char)

      <<
        list::bitstring,
        char_as_binary::bitstring
      >>
    end)
  end

  def encode_huffman_tree(node)

  def encode_huffman_tree(%Leaf{val: val}) do
    <<1::size(1), val::bitstring>>
  end

  def encode_huffman_tree(%Node{left: left, right: right}) do
    <<
      0::size(1),
      encode_huffman_tree(left)::bitstring,
      encode_huffman_tree(right)::bitstring
    >>
  end

  def decode_huffman_tree(<<1::size(1), value::binary-size(1), rest::bitstring>>) do
    {
      %Leaf{val: value},
      rest
    }
  end

  def decode_huffman_tree(<<0::size(1), rest::bitstring>>) do
    {left, rest} = decode_huffman_tree(rest)
    {right, rest} = decode_huffman_tree(rest)

    {
      %Node{
        left: left,
        right: right
      },
      rest
    }
  end
end
