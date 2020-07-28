defmodule Huffman.Utils do
  @doc """
  bytes/1 takes a bitstring and chunks it in byte (8 bit) chunks.
  """
  @spec bytes(bitstring()) :: [<<_::8>>]
  def bytes(bitstring) do
    for <<byte::binary-size(1) <- bitstring>>, do: byte
  end
end
