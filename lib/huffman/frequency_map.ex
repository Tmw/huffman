defmodule Huffman.FrequencyMap do
  @moduledoc """
  Module to count the frequency per character in the given input text
  """

  import Huffman.Utils, only: [bytes: 1]

  @doc """
  create/1 returns a map with each byte (character) and its frequency
  within the given input.
  """
  @spec create(data :: binary()) :: map()
  def create(data) do
    data
    |> bytes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.update(acc, char, 1, fn val -> val + 1 end)
    end)
  end
end
