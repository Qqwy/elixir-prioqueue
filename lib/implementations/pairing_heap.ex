defmodule Prioqueue.Implementations.PairingHeap do
  alias __MODULE__
  @moduledoc """
  An implementation of a Priority Queue built on top of a Pairing Heap.

  Pairing Heaps are nearly as simple as Skew Heaps but are in many contexts
  the fastest kind of priority queue implementation known.

  Pairing Heaps have amortized time bounds.

  More information about Pairing Heaps can be found in [Issue #16 of the Monad.Reader](https://themonadreader.files.wordpress.com/2010/05/issue16.pdf).
  """


  # Contents: pairing_heap
  # pairing_heap: nil | {val, [pairing_heap]}
  defstruct contents: nil, cmp_fun: &Prioqueue.Helper.cmp/2

  def empty(opts) do
    cmp_fun = Keyword.get(opts, :cmp_fun, &Prioqueue.Helper.cmp/2)
    %PairingHeap{cmp_fun: cmp_fun}
  end

  def combine(%PairingHeap{contents: heap1, cmp_fun: cmp_fun}, %PairingHeap{contents: heap2}) do
    combine(heap1, heap2, cmp_fun)
  end

  # Used by multiple protocol implementations directly.
  @doc false
  def combine(heap1, heap2, cmp_fun)
  def combine(heap1, nil, _), do: heap1
  def combine(nil, heap2, _), do: heap2
  def combine(heap1 = {x1, ts1}, heap2 = {x2, ts2}, cmp_fun) do
    if cmp_fun.(x1, x2) in [:lt, :eq] do
      {x1, [heap2 | ts1]}
    else
      {x2, [heap1 | ts2]}
    end
  end

  defimpl Prioqueue.Protocol do
    def insert(pqueue = %PairingHeap{contents: nil}, item) do
      %PairingHeap{pqueue | contents: {item, []}}
    end
    def insert(pqueue = %PairingHeap{contents: heap1, cmp_fun: cmp_fun}, item) do
      %PairingHeap{pqueue | contents: PairingHeap.combine(heap1, {item, []}, cmp_fun)}
    end

    def extract_min(%PairingHeap{contents: nil}), do: :error
    def extract_min(pqueue = %PairingHeap{contents: {val, ts}, cmp_fun: cmp_fun}) do
      result_pqueue = %PairingHeap{pqueue | contents: meld_children(ts, cmp_fun)}
      {:ok, {val, result_pqueue}}
    end

    defp meld_children([], _cmp_fun), do: nil
    defp meld_children([single_heap], _cmp_fun), do: single_heap
    defp meld_children([t1, t2 | ts], cmp_fun), do: PairingHeap.combine(PairingHeap.combine(t1, t2, cmp_fun), meld_children(ts, cmp_fun), cmp_fun)

    def to_list(%PairingHeap{contents: heap1, cmp_fun: cmp_fun}) do
      to_list(heap1, cmp_fun, [])
      |> :lists.reverse
    end

    defp to_list(nil, _cmp_fun, acc), do: acc
    defp to_list({val, ts}, cmp_fun, acc) do
      res = meld_children(ts, cmp_fun)
      to_list(res, cmp_fun, [val | acc])
    end

    def member?(%PairingHeap{contents: contents, cmp_fun: cmp_fun}, item) do
      member?(contents, item, cmp_fun)
    end

    defp member?(nil, _item, _cmp_fun), do: false
    defp member?({val, ts}, item, cmp_fun) do
      (cmp_fun.(item, val) == :eq) || Enum.any?(ts, &member?(&1, item, cmp_fun))
    end

    def size(%PairingHeap{contents: contents}) do
      calc_size(contents)
    end

    # TODO Tail recursive using zipper?
    defp calc_size(nil), do: 0
    defp calc_size({_, ts}), do: 1 + (Enum.map(ts, &calc_size(&1)) |> Enum.sum())

    def empty?(%PairingHeap{contents: nil}), do: true
    def empty?(%PairingHeap{}), do: false
  end
end
