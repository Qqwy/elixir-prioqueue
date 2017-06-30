defmodule Prioqueue.Helper do
  @doc """
  Performs comparison of elements
  based on Erlang's built-in term ordering.
  """
  def cmp(a, b) when a < b, do: :lt
  def cmp(a, b) when a == b, do: :eq
  def cmp(_a, _b), do: :gt

  @doc """
  Compares two items but returns the inverse result,
  meaning that if `a` is smaller than `b`, :gt will be returned.

  This is useful to transform a Priority Queue (which by default functions as a minimum queue) to a maximum queue.
  """
  def cmp_inverse(a, b, cmp_fun \\ &cmp/2) do
    case cmp_fun.(a, b) do
      :lt -> :gt
      :eq -> :eq
      :gt -> :lt
    end
  end
end
