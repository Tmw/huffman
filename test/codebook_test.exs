defmodule CodebookTest do
  use ExUnit.Case
  alias Huffman.{Codebook, Node, Leaf}

  @sample_tree %Node{
    left: %Node{
      left: %Leaf{val: "a"},
      right: %Leaf{val: "b"}
    },
    right: %Leaf{val: "c"}
  }

  describe "#from_tree/1" do
    test "builds a codebook from a tree" do
      assert %{
               "a" => <<0::size(2)>>,
               "b" => <<1::size(2)>>,
               "c" => <<1::size(1)>>
             } = Codebook.from_tree(@sample_tree)
    end
  end

  describe "#encode/2" do
    test "encode test into bitstring" do
      codebook = Codebook.from_tree(@sample_tree)
      encoded = Codebook.encode(codebook, "ccabc")

      assert <<99::size(7)>> = encoded
      assert bit_size(encoded) == 7
    end
  end
end
