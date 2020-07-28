defmodule Huffman.Queue do
  @type queue :: [{integer(), any()}]

  @doc """
  from_map/1 takes a map with %{value => frequency}
  and returns an array with that order
  """
  @spec from_map(map()) :: queue
  def from_map(map) do
    queue =
      for {k, v} <- map do
        {v, k}
      end

    queue |> sort()
  end

  @doc """
  push/3 takes the queue, an priority and an item to store with the given
  priority and returns an updated queue with given item included.
  """
  @spec push(queue(), integer(), any()) :: queue()
  def push(queue, frequency, item) do
    sort([{frequency, item}] ++ queue)
  end

  @doc """
  pop/1 returns the item with the lowest priority and the remainder
  of the queue as a tuple.
  """
  @spec pop(queue()) :: {any(), queue()}
  def pop([item | queue]) do
    {item, queue}
  end

  @doc """
  map/2 takes a queue and a mapper function to perform transformations
  on the queue's values.
  """
  @spec map(queue, (any() -> any())) :: queue()
  def map(queue, func) do
    Enum.map(queue, fn {prio, item} ->
      {prio, func.(item)}
    end)
  end

  @doc """
  length/1 returns the number of items in the queue
  """
  @spec length(queue()) :: non_neg_integer()
  def length(queue) do
    Kernel.length(queue)
  end

  defp sort(queue) do
    Enum.sort_by(queue, fn {freq, _} -> freq end)
  end
end
