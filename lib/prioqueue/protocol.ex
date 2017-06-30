defprotocol Prioqueue.Protocol do
  @type prioqueue :: t

  @doc """
  Inserts `item` at the correct ordering place inside `prioqueue`,

  according to the ordering introduced by the Priority Queue's `cmp_fun`.

  Runs in O(log n).
  """
  @spec insert(prioqueue, item :: any) :: {:ok, prioqueue} | :error
  def insert(prioqueue, item)


  @doc """
  Extracts the current minimum from the Priority Queue,
  according to the ordering introduced by the Priority Queue's `cmp_fun`.

  Runs in O(log n).

  Returns `{:ok, {item, priority_queue_without_item}}`, or `:error` if the priority queue is empty.
  """
  @spec extract_min(prioqueue) :: {:ok, {item :: any, prioqueue}} | :error
  def extract_min(prioqueue)


  @doc """
  Peeks at the current minimum item from the Priority Queue,
  according to the ordering introduced by the Priority Queue's `cmp_fun`.

  Runs in O(1).

  Returns `{:ok, item}`, or `:error` if the priority queue is empty.
  """
  @spec peek_min(Prioqueue.t) :: {:ok, item :: any} | :error
  def peek_min(prioqueue)

  @doc """
  Returns the number of elements currently stored in the Priority Queue.
  """
  @spec size(prioqueue) :: non_neg_integer
  def size(prioqueue)

  @doc """
  Returns the Priority Queue in list form.

  Note that the first-to-be-extracted element appears as the head of the list.
  """
  @spec to_list(prioqueue) :: list()
  def to_list(prioqueue)

  @doc """
  Returns `true` if data equal to `item` is inside of `prioqueue`,

  according to the result of calling the priority queue's comparison function.
  """
  @spec member?(prioqueue, item :: any) :: boolean
  def member?(prioqueue, item)

  @doc """
  Returns `true` if (and only if) the Priority Queue is empty.

  This is a lot faster than checking if the size is nonzero.
  """
  @spec empty?(prioqueue) :: boolean
  def empty?(prioqueue)
end
