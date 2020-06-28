defmodule Huffman.Encoder do
  alias Huffman.{Leaf, Node}

  @spec encode(String.t()) :: {binary(), map()}
  def encode(text) do
    huffman_tree =
      text
      |> build_frequency_map()
      |> to_leafs()
      |> sort_by_frequency()
      |> build_tree()

    # generate a codebook from the Huffman tree, mapping
    # each used character to its binary path in the tree.
    codebook = to_codebook(huffman_tree)

    # re-encode the same text based on the codebook
    encoded = to_binary(text, codebook)

    # calculate how many bits we need to add to land
    # on a valid binary (next multiple of 8)
    padding = ceil(bit_size(encoded) / 8) * 8 - bit_size(encoded)

    # return compressed representation and codebook
    {<<
       encoded::bitstring,
       0::size(padding)
     >>, huffman_tree}
  end

  defp build_frequency_map(text) do
    text
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.update(acc, char, 1, fn val -> val + 1 end)
    end)
  end

  defp to_leafs(map) do
    for {val, freq} <- map do
      %Leaf{val: val, freq: freq}
    end
  end

  defp sort_by_frequency(nodes) do
    Enum.sort_by(nodes, fn %{freq: freq} -> freq end)
  end

  defp build_tree([first, second | rest]) do
    node = %Node{
      left: first,
      right: second,
      freq: first.freq + second.freq
    }

    build_tree(rest ++ [node])
  end

  defp build_tree([node]), do: node

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
    |> String.graphemes()
    |> Enum.reduce(<<>>, fn char, list ->
      char_as_binary = Map.get(codebook, char)

      <<
        list::bitstring,
        char_as_binary::bitstring
      >>
    end)
  end
end
