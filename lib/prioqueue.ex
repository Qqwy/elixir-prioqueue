defmodule Prioqueue do
  @moduledoc """
  Priority Queue implementation.

  The nested modules contain multiple different implementations for priority queues.

  This module can be used to dispatch to them. The used implementation can be altered as a configuration setting,
  to allow for the most efficient implementation for your application.


  ## Examples:

  iex> pqueue = (
  iex> Prioqueue.new()
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


  ## Configuration settings

  The behaviour of Prioqueue can be altered per call by passing options to `new`, or by writing down application-wide configuration options for the application `:prioqueue`:

  - `:default_implementation`: The Priority Queue implementation to use.
  - `:default_comparison_function`: The comparison function that should be used to keep the Priority Queue ordered.

  """

  @doc """
  `new` listens to these options:

  - `:implementation`: The Priority Queue implementation to be used. By default, `Prioqueue.Implementation.SkewHeap` is used.
  - `:cmp_fun`: The comparison function that should be used to keep the Priority Queue ordered. By default, will use `Prioqueue.Helper.cmp/2`, which uses the default Erlang Term Ordering.
  """
    def new(opts \\ []) do
    implementation = Keyword.get(opts, :implementation, Application.get_env(:prioqueue, :default_implementation, Prioqueue.Implementations.SkewHeap))
    cmp_fun = Keyword.get(opts, :cmp_fun, Application.get_env(:prioqueue, :default__comparison_function, &Prioqueue.Helper.cmp/2))
    implementation.new(cmp_fun: cmp_fun)
  end

  defdelegate insert(prioqueue, item), to: Prioqueue.Protocol
  defdelegate extract_min(prioqueue), to: Prioqueue.Protocol
  defdelegate size(prioqueue), to: Prioqueue.Protocol
  defdelegate to_list(prioqueue), to: Prioqueue.Protocol
  defdelegate member?(prioqueue, item), to: Prioqueue.Protocol
end
