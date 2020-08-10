defmodule Huffman.Encoder do
  alias Huffman.{Codebook, Tree, FrequencyMap, Packer, Queue}

  @spec encode(String.t()) :: {:ok, Packer.packed_data()}
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

    packed =
      tree
      |> Tree.serialize()
      |> Packer.pack(encoded)

    {:ok, packed}
  end
end
