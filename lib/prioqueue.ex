defmodule Prioqueue do
  @type t :: Prioqueue.Protocol.t

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

  The various Prioqueue Implementations implement the following protocols:


  ### `Collectable`

  which allows transforming a collection into a Prioqueue.

      iex> Enum.into([1,2,3,4], Prioqueue.empty())
      #Prioqueue.Implementations.SkewHeap<[1, 2, 3, 4]>

  ### `Enumerable`

  which allows transforming a Prioqueue into another collection.

      iex> pqueue = Enum.into([1, 2, 3, 10, 5, 2], Prioqueue.empty())
      #Prioqueue.Implementations.SkewHeap<[1, 2, 2, 3, 5, 10]>
      iex> Enum.map(pqueue, fn x -> x * 2 end)
      [2, 4, 4, 6, 10, 20]

  ### `FunLand.Reducable`

  which allows the reduction of a Prioqueue into some other value.

      iex> pqueue = Enum.into([1, 2, 3, 10, 5, 2], Prioqueue.empty())
      iex> FunLand.Reducable.reduce(pqueue, 0, fn acc, x -> acc + x end)
      23

  ### `FunLand.Combinable`

  which allows to merge two Prioqueues together.

      iex> pqueue = Enum.into([1, 3, 5], Prioqueue.empty())
      iex> pqueue2 = Enum.into([1, 2, 3, 4], Prioqueue.empty())
      iex> FunLand.Combinable.combine(pqueue, pqueue2)
      #Prioqueue.Implementations.SkewHeap<[1, 1, 2, 3, 3, 4, 5]>

  ### `Extractable`

  which allows extracting a single element from the Prioqueue.

      iex> Extractable.extract(Prioqueue.empty())
      {:error, :empty}

      iex> pqueue = Enum.into([1, 3, 5], Prioqueue.empty())
      iex> {:ok, {item, pqueue_rest}} = Extractable.extract(pqueue)
      iex> item
      1
      iex> pqueue_rest
      #Prioqueue.Implementations.SkewHeap<[3, 5]>


  ### `Insertable`

  which allows inserting a single element into the Prioqueue.


      iex> {:ok, pqueue} = Insertable.insert(Prioqueue.empty(), 4)
      iex> pqueue
      #Prioqueue.Implementations.SkewHeap<[4]>

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

  @doc """
  Inserts `item` at the correct ordering place inside `prioqueue`,

  according to the ordering introduced by the Priority Queue's `cmp_fun`.

  Runs in O(log n).
  """
  @spec insert(Prioqueue.t, item :: any) :: Prioqueue.t
  defdelegate insert(prioqueue, item), to: Prioqueue.Protocol

  @doc """
  Extracts the current minimum from the Priority Queue,
  according to the ordering introduced by the Priority Queue's `cmp_fun`.

  Runs in O(log n).

  Returns `{:ok, {item, priority_queue_without_item}}`, or `{:error, :empty}` if the priority queue is empty.
  """
  @spec extract_min(Prioqueue.t) :: {:ok, {item :: any, Prioqueue.t}} | {:error, :empty}
  defdelegate extract_min(prioqueue), to: Prioqueue.Protocol

  @doc """
  Variant of extract_min/1 that raises on failure (when the priority queue is empty).
  """
  @spec extract_min!(Prioqueue.t) :: {item :: any, Prioqueue.t}
  def extract_min!(prioqueue) do
    {:ok, result} = extract_min(prioqueue)
    result
  end

  @doc """
  Peeks at the current minimum item from the Priority Queue,
  according to the ordering introduced by the Priority Queue's `cmp_fun`.

  Runs in O(1).

  Returns `{:ok, item}`, or `{:error, :empty}` if the priority queue is empty.
  """
  @spec peek_min(Prioqueue.t) :: {:ok, item :: any} | {:error, :empty}
  defdelegate peek_min(prioqueue), to: Prioqueue.Protocol

  @doc """
  Variant of peek_min/1 that raises on failure (when the priority queue is empty).
  """
  @spec peek_min!(Prioqueue.t) :: any
  def peek_min!(prioqueue) do
    {:ok, item} = peek_min(prioqueue)
    item
  end

  @doc """
  Returns the number of elements currently stored in the Priority Queue.
  """
  @spec size(Prioqueue.t) :: non_neg_integer
  defdelegate size(prioqueue), to: Prioqueue.Protocol

  @doc """
  Returns the Priority Queue in list form.

  Note that the first-to-be-extracted element appears as the head of the list.
  """
  @spec to_list(Prioqueue.t) :: list()
  defdelegate to_list(prioqueue), to: Prioqueue.Protocol

  @doc """
  Returns `true` if data equal to `item` is inside of `prioqueue`,

  according to the result of calling the priority queue's comparison function.
  """
  @spec member?(Prioqueue.t, item :: any) :: boolean
  defdelegate member?(prioqueue, item), to: Prioqueue.Protocol

  @doc """
  Returns `true` if (and only if) the Priority Queue is empty.

  This is a lot faster than checking if the size is nonzero.
  """
  @spec empty?(Prioqueue.t) :: boolean
  defdelegate empty?(prioqueue), to: Prioqueue.Protocol
end
