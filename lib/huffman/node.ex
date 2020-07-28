defmodule Huffman.Node do
  @type child :: Huffman.Node.t() | Huffman.Leaf.t() | nil
  @type t :: %Huffman.Node{left: child, right: child}
  defstruct [:left, :right]
end
