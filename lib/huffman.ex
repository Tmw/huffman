defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """

  defdelegate encode(text), to: Huffman.Encoder
  defdelegate decode(data), to: Huffman.Decoder
end
