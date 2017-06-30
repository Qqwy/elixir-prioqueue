defprotocol Prioqueue.Protocol do
  @type prioqueue :: t

  @spec insert(prioqueue, item :: any) :: {:ok, prioqueue} | :error
  def insert(prioqueue, item)

  @spec extract_min(prioqueue) :: {:ok, {item :: any, prioqueue}} | :error
  def extract_min(prioqueue)

  @spec size(prioqueue) :: non_neg_integer
  def size(prioqueue)

  @spec to_list(prioqueue) :: list()
  def to_list(prioqueue)

  @spec member?(prioqueue, item :: any) :: boolean
  def member?(prioqueue, item)

  @spec empty?(prioqueue) :: boolean
  def empty?(prioqueue)
end
