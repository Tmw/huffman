defmodule Huffman.Codebook do
  import Huffman.Utils, only: [bytes: 1]
  alias Huffman.{Node, Leaf}

  @type encoded_data() :: bitstring()

  @doc """
  from_tree/1 returns a map of %{binary() => bitstring()} based on the position
  in the binary tree.
  """
  @spec from_tree(Node.t()) :: map()
  def from_tree(%Node{} = tree) do
    build(tree)
  end

  @doc """
  encode/2 returns an encoded bitstring as a result of mapping each 8 bits in the
  input text against the codebook and writing their Huffman code instead.
  """
  @spec encode(map(), binary()) :: encoded_data()
  def encode(codebook, text) do
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

  defp build(node, steps \\ [], book \\ %{})

  defp build(%Node{left: left, right: right}, steps, book) do
    book = build(left, steps ++ [0], book)
    build(right, steps ++ [1], book)
  end

  defp build(%Leaf{val: val}, steps, map) do
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
end
