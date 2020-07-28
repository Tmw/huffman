defmodule FrequencyMapTest do
  use ExUnit.Case
  alias Huffman.FrequencyMap

  describe "create/1" do
    test "returns map with frequencies" do
      output = FrequencyMap.create("some text")

      assert %{
               "s" => 1,
               "o" => 1,
               "m" => 1,
               "e" => 2,
               " " => 1,
               "t" => 2,
               "x" => 1
             } = output
    end
  end
end
