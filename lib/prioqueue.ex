defmodule Prioqueue do
  @moduledoc """
  Priority Queue implementation.

  The nested modules contain multiple different implementations for priority queues.

  This module can be used to dispatch to them. The used implementation can be altered as a configuration setting,
  to allow for the most efficient implementation for your application.


  ## Examples:

  iex> (
  iex> Prioqueue.new()
  iex> |> Prioqueue.insert(10)
  iex> |> Prioqueue.insert(20)
  iex> |> Prioqueue.insert(15)
  iex> |> Prioqueue.insert(100)
  iex> )
  #Prioqueue.Implementations.SkewHeap<[10, 15, 20, 100]>
  """

  def new() do
    implementation = Application.get_env(:prioqueue, :default_prioqueue_implementation, Prioqueue.Implementations.SkewHeap)
    implementation.new()
  end

  def new(implementation) do
    implementation.new()
  end

  defdelegate insert(prioqueue, element), to: Prioqueue.Protocol
  defdelegate extract_min(prioqueue, element), to: Prioqueue.Protocol
  defdelegate size(prioqueue, element), to: Prioqueue.Protocol
  defdelegate to_list(prioqueue, element), to: Prioqueue.Protocol
  defdelegate member?(prioqueue, element), to: Prioqueue.Protocol
end
