defmodule Prioqueue do
  @moduledoc """
  Priority Queue implementation.

  The nested modules contain multiple different implementations for priority queues.

  This module can be used to dispatch to them. The used implementation can be altered as a configuration setting,
  to allow for the most efficient implementation for your application.


  ## Examples

      iex> pqueue = (
      iex> Prioqueue.empty()
      iex> |> Prioqueue.insert(10)
      iex> |> Prioqueue.insert(20)
      iex> |> Prioqueue.insert(15)
      iex> |> Prioqueue.insert(100)
      iex> )
      #Prioqueue.Implementations.SkewHeap<[10, 15, 20, 100]>
      iex> Prioqueue.member?(pqueue, 20)
      true
      iex> {:ok, {item, pqueue_rest}} = Prioqueue.extract_min(pqueue)
      iex> item
      10
      iex> pqueue_rest
      #Prioqueue.Implementations.SkewHeap<[15, 20, 100]>

  ## Protocols

      iex> pqueue = Enum.into([1, 2, 3, 10, 5, 2], Prioqueue.empty())
      #Prioqueue.Implementations.SkewHeap<[1, 2, 2, 3, 5, 10]>
      iex> Enum.map(pqueue, fn x -> x * 2 end)
      [2, 4, 4, 6, 10, 20]

  ## Configuration settings

  The behaviour of Prioqueue can be altered per call by passing options to `new`, or by writing down application-wide configuration options for the application `:prioqueue`:

  - `:default_implementation`: The Priority Queue implementation to use.
  - `:default_comparison_function`: The comparison function that should be used to keep the Priority Queue ordered.

  """

  @doc """
  Creates a new, empty priority queue.


  `empty` listens to these options:

  - `:implementation`: The Priority Queue implementation to be used. By default, `Prioqueue.Implementation.SkewHeap` is used.
  - `:cmp_fun`: The comparison function that should be used to keep the Priority Queue ordered. By default, will use `Prioqueue.Helper.cmp/2`, which uses the default Erlang Term Ordering.
  """
  def empty(opts \\ []) do
    implementation = Keyword.get(opts, :implementation, Application.get_env(:prioqueue, :default_implementation, Prioqueue.Implementations.SkewHeap))
    cmp_fun = Keyword.get(opts, :cmp_fun, Application.get_env(:prioqueue, :default__comparison_function, &Prioqueue.Helper.cmp/2))
    implementation.empty(cmp_fun: cmp_fun)
  end

  defdelegate insert(prioqueue, item), to: Prioqueue.Protocol
  defdelegate extract_min(prioqueue), to: Prioqueue.Protocol
  def extract_min!(prioqueue) do
    {:ok, result} = extract_min(prioqueue)
    result
  end

  def peek_min(prioqueue) do
    case extract_min(prioqueue) do
      {:ok, {item, _}} -> {:ok, item}
      other -> other
    end
  end

  def peek_min!(prioqueue) do
    {:ok, item} = peek_min(prioqueue)
    item
  end

  defdelegate size(prioqueue), to: Prioqueue.Protocol
  defdelegate to_list(prioqueue), to: Prioqueue.Protocol
  defdelegate member?(prioqueue, item), to: Prioqueue.Protocol
  defdelegate empty?(prioqueue), to: Prioqueue.Protocol
end
