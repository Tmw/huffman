defmodule Huffman do
  @moduledoc """
  Documentation for `Huffman`.
  """
  @default """
  a simple string
  """

  defdelegate encode(text \\ @default), to: Huffman.Encoder

  defdelegate decode(text, tree), to: Huffman.Decoder
end
