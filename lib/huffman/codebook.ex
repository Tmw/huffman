defmodule Huffman.Codebook do
  import Huffman.Utils, only: [bytes: 1]
  alias Huffman.{Node, Leaf}

  def from_tree(node) do
    build(node)
  end

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
