defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """

  defdelegate encode(text), to: Huffman.Encoder
  defdelegate decode(text, tree), to: Huffman.Decoder
end
