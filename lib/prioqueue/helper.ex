defmodule Prioqueue.Helper do
  @doc """
  Performs comparison of elements
  based on Erlang's built-in term ordering.
  """
  def cmp(a, b) when a < b, do: :lt
  def cmp(a, b) when a == b, do: :eq
  def cmp(a, b), do: :gt
end
