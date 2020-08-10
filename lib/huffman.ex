defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """

  defdelegate encode(text), to: Huffman.Encoder
  defdelegate decode(text), to: Huffman.Decoder
end
