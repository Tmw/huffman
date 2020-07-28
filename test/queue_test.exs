defmodule QueueTest do
  use ExUnit.Case
  alias Huffman.Queue

  describe "#from_map/1" do
    test "creates queue from map" do
      map = %{"a" => 12, "b" => 7, "c" => 27}

      assert Queue.from_map(map) == [
               {7, "b"},
               {12, "a"},
               {27, "c"}
             ]
    end
  end

  describe "#push/3" do
    test "includes the item in correct order" do
      queue = Queue.from_map(%{"c" => 7, "a" => 2})
      queue = queue |> Queue.push(5, "b")

      assert queue == [
               {2, "a"},
               {5, "b"},
               {7, "c"}
             ]
    end
  end

  describe "#pop/1" do
    test "returns first item and rest of the queue" do
      queue = Queue.from_map(%{"c" => 7, "a" => 2, "b" => 5})

      assert {
               {2, "a"},
               [
                 {5, "b"},
                 {7, "c"}
               ]
             } = Queue.pop(queue)
    end
  end

  describe "#map/2" do
    test "transforms the items in the queue" do
      queue = Queue.from_map(%{"c" => 7, "a" => 2, "b" => 5})

      assert [
               {2, "ax"},
               {5, "bx"},
               {7, "cx"}
             ] = Queue.map(queue, fn item -> item <> "x" end)
    end
  end

  describe "#length/1" do
    test "return number of items in queue" do
      queue = Queue.from_map(%{"c" => 7, "a" => 2, "b" => 5})
      assert 3 == Queue.length(queue)
    end
  end
end
