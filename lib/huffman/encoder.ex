defmodule Huffman.Encoder do
  alias Huffman.{Codebook, Tree, FrequencyMap, Queue}

  @spec encode(String.t()) :: {:ok, binary(), map()}
  def encode(text) do
    tree =
      text
      |> FrequencyMap.create()
      |> Queue.from_map()
      |> Tree.build()

    encoded =
      tree
      |> Codebook.from_tree()
      |> Codebook.encode(text)

    {:ok, encoded, tree}
  end
end
