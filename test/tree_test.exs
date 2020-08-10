defmodule TreeTest do
  use ExUnit.Case
  alias Huffman.{Queue, Tree, Node, Leaf}

  @sample_tree %Node{
    left: %Node{
      left: %Leaf{val: "a"},
      right: %Leaf{val: "b"}
    },
    right: %Leaf{val: "c"}
  }

  @bit_representation <<44, 54, 43, 3::size(5)>>

  describe "#build/1" do
    map = %{
      "a" => 1,
      "b" => 2,
      "c" => 5
    }

    queue = Queue.from_map(map)
    tree = Tree.build(queue)

    assert @sample_tree == tree
  end

  describe "#serialize/1" do
    test "serializes to bitstring" do
      assert Tree.serialize(@sample_tree) == @bit_representation
    end
  end

  describe "#deserialize/1" do
    assert Tree.deserialize(@bit_representation) == {:ok, @sample_tree}
  end
end
