defmodule Huffman.Decoder do
  alias Huffman.{Leaf, Node}

  @doc """
  given a bitstring and a root node of the huffman tree, decode it until the
  bitstring is empty.
  """
  @spec decode(bitstring(), Node.t()) :: binary()
  def decode(binary, tree, result \\ [])

  def decode(<<>>, %Node{} = _tree, result), do: :unicode.characters_to_binary(result)

  def decode(binary, %Node{} = tree, result) do
    {rest, value} = walk(binary, tree)
    decode(rest, tree, result ++ [value])
  end

  defp walk(<<0::size(1), rest::bitstring>>, %Node{left: left}) do
    walk(rest, left)
  end

  defp walk(<<1::size(1), rest::bitstring>>, %Node{right: right}) do
    walk(rest, right)
  end

  defp walk(binary, %Leaf{val: val}), do: {binary, val}
end
