defmodule Huffman.Utils do
  # chunk the binary stream into bytes (8-bits)
  def bytes(bitstring) do
    for <<byte::binary-size(1) <- bitstring>>, do: byte
  end
end
