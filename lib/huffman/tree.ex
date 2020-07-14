defmodule Huffman.Tree do
  alias Huffman.{Leaf, Node}
  import Huffman.Utils, only: [bytes: 1]

  def build(data) do
    data
    |> build_frequency_map()
    |> to_leafs()
    |> sort_by_frequency()
    |> build_tree()
  end

  # build a map with the characters (bytes) and their frequencies in the given input data.
  defp build_frequency_map(data) do
    data
    |> bytes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.update(acc, char, 1, fn val -> val + 1 end)
    end)
  end

  # from the frequency map generate leaf nodes. Each leaf
  # node is represented as a tuple. eg: {frequency, %Node{}}
  defp to_leafs(map) do
    for {val, freq} <- map do
      {freq, %Leaf{val: val}}
    end
  end

  # sort all the nodes based on the frequency in ascending order.
  defp sort_by_frequency(nodes) do
    Enum.sort_by(nodes, fn {freq, _} -> freq end)
  end

  # building the tree by taking the first two elements of the list and combine them into a left and a right node. The new element will be placed back into the list with the totalled frequency.

  # The exit condition is when we've reached a list with only one node in it (the root node).

  defp build_tree([first, second | rest]) do
    {freq_first, node_first} = first
    {freq_second, node_second} = second

    node = %Node{
      left: node_first,
      right: node_second
    }

    build_tree(rest ++ [{freq_first + freq_second, node}])
  end

  defp build_tree([{_freq, node}]), do: node
end
