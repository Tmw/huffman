defmodule Huffman.Tree do
  alias Huffman.{Leaf, Node, Queue}
  @type tree :: %Node{left: Node.child(), right: Node.child()}
  @type serialized_tree() :: bitstring()

  @doc """
  build/1 takes the priority queue and transforms it into a binary tree
  with the lowest priorities as leafs furthest from the root and more higher
  priorities closer to the root.
  """
  @spec build(Queue.queue()) :: tree()
  def build(queue) do
    # transform items to leafs
    queue = queue |> Queue.map(&to_leaf/1)

    # start building the tree
    build_tree(queue)
  end

  defp build_tree(queue) do
    {{freq_first, value_first}, queue} = queue |> Queue.pop()
    {{freq_second, value_second}, queue} = queue |> Queue.pop()

    node = %Node{
      left: value_first,
      right: value_second
    }

    queue = queue |> Queue.push(freq_first + freq_second, node)

    if Queue.length(queue) > 1 do
      build_tree(queue)
    else
      {{_freq, tree}, _queue} = queue |> Queue.pop()
      tree
    end
  end

  defp to_leaf(item) do
    %Leaf{val: item}
  end

  @doc """
  serialize/1 takes the tree and outputs its serialized representation
  """
  @spec serialize(Node.t()) :: serialized_tree()
  def serialize(node)

  def serialize(%Leaf{val: val}) do
    <<1::size(1), val::bitstring>>
  end

  def serialize(%Node{left: left, right: right}) do
    <<
      0::size(1),
      serialize(left)::bitstring,
      serialize(right)::bitstring
    >>
  end

  @doc """
  deserialize/1 takes the serialized tree and returns a populated binary tree.
  """
  @spec deserialize(serialized_tree()) :: {:ok, Node.child()}
  def deserialize(serialized_tree) do
    with {node, _rest} <- read(serialized_tree) do
      {:ok, node}
    end
  end

  defp read(<<1::size(1), value::binary-size(1), rest::bitstring>>) do
    {
      %Leaf{val: value},
      rest
    }
  end

  defp read(<<0::size(1), rest::bitstring>>) do
    {left, rest} = read(rest)
    {right, rest} = read(rest)

    node = %Node{
      left: left,
      right: right
    }

    {node, rest}
  end
end
