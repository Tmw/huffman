defmodule Huffman.Packer do
  alias Huffman.{Codebook, Tree}

  @moduledoc """
  This module will take the encoded tree and data and pack it into a single
  binary that has the following format:

  +---------+----------+----------+----------+
  |  header |   tree   |   data   |  padding |
  +---------+----------+----------+----------+
  | 35 bits | variable | variable | < 8 bits |
  +---------+----------+----------+----------+


  The first 35 bits is reserved for the header. The header describes the layout
  of the rest of the packet. The header itself is made up of two parts:

  - The first 32 bits describe the length of the tree. This is the number of bits
  following the header that contain the tree.

  - The last 3 bits describe the padding at the end of the binary and can be
  safely ignored when reading the blob. Its use is purely to round the number
  of bits to the nearest binary (multiple of 8). Required to write to disk for example.

  """

  @header_size 35
  @type packed_data :: binary()

  @doc """
  pack/2 takes the serialized tree and encoded data and returns padded bitstring
  to form binary.
  """
  @spec pack(Tree.serialized_tree(), Codebook.encoded_data()) :: packed_data()
  def pack(tree, encoded) do
    tree_size = bit_size(tree)
    data_size = bit_size(encoded)

    # from the total we need to calculate the padding we'd need to add
    # at the end of the bitstream to land on a valid binary (multiple of 8).
    total_size = tree_size + data_size + @header_size
    padding_size = 8 - rem(total_size, 8)

    <<
      make_header(tree_size, padding_size)::bitstring(),
      tree::bitstring(),
      encoded::bitstring(),
      0::size(padding_size)
    >>
  end

  @spec unpack(packed_data()) ::
          {:ok, Tree.serialized_tree(), Codebook.encoded_data()}
          | {:error, :invalid_binary}
  def unpack(packed_data) when is_binary(packed_data) do
    with {:ok, tree, data} <- deconstruct_binary(packed_data) do
      {:ok, tree, data}
    else
      _ ->
        {:error, :invalid_binary}
    end
  end

  defp deconstruct_binary(packed_data) do
    with <<tree_size::size(32), padding::size(3), rest::bitstring()>> <- packed_data,
         <<tree::bitstring-size(tree_size), rest::bitstring()>> <- rest,
         data_length <- bit_size(rest) - padding,
         <<data::bitstring-size(data_length), _rest::bitstring>> <- rest do
      {:ok, tree, data}
    end
  end

  defp make_header(tree_size, padding_size) do
    <<
      tree_size::size(32),
      padding_size::size(3)
    >>
  end
end
