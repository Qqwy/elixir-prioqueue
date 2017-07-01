defmodule Prioqueue.Implementations.SkewHeap do
  alias __MODULE__

  @moduledoc """
  An implementation of a Priority Queue built on top of a Skew Heap.

  A Skew Heap is very simple, which means that this implementation is
  also quite concise: All operations are built on top of a 'combine' procedure.

  To improve efficiency, the internal heap is stored as tuples representing tree nodes
  (rather than structs representing tree nodes)


  More information about Skew Heaps can be found in [Issue #16 of the Monad.Reader](https://themonadreader.files.wordpress.com/2010/05/issue16.pdf).
  """

  # `contents` is either `nil` or `{value, left_tree, right_tree}`
  defstruct contents: nil, cmp_fun: &Prioqueue.Helper.cmp/2

  # FunLand Behaviours, and autogenerates Enumerable and Collectable protocol definitions.
  use FunLand.Combinable
  use FunLand.Reducable

  def empty(opts \\ []) do
    cmp_fun = Keyword.get(opts, :cmp_fun, &Prioqueue.Helper.cmp/2)
    %SkewHeap{cmp_fun: cmp_fun}
  end

  def combine(pqueue1 = %SkewHeap{contents: heap1, cmp_fun: cmp_fun}, %SkewHeap{contents: heap2}) do
    %SkewHeap{pqueue1 | contents: combine(heap1, heap2, cmp_fun)}
  end

  # Used by multiple protocol implementations directly.
  @doc false
  def combine(nil, heap2, _), do: heap2
  def combine(heap1, nil, _), do: heap1
  def combine(heap1 = {x1, l1, r1}, heap2 = {x2, l2, r2}, cmp_fun) do
    if cmp_fun.(x1, x2) in [:lt, :eq] do
      {x1, combine(heap2, r1, cmp_fun), l1}
    else
      {x2, combine(heap1, r2, cmp_fun), l2}
    end
  end

  def reduce(prioqueue, acc, fun) do
    case Prioqueue.Protocol.extract_min(prioqueue) do
      {:ok, {item, rest}} ->
        reduce(rest, fun.(acc, item), fun)
      {:error, :empty} ->
        acc
    end
  end

  defimpl Prioqueue.Protocol do
    def insert(pqueue = %SkewHeap{contents: nil}, item) do
      %SkewHeap{pqueue | contents: {item, nil, nil}}
    end
    def insert(pqueue = %SkewHeap{contents: heap1, cmp_fun: cmp_fun}, item) do
      %SkewHeap{pqueue | contents: SkewHeap.combine(heap1, {item, nil, nil}, cmp_fun)}
    end

    def extract_min(%SkewHeap{contents: nil}), do: {:error, :empty}
    def extract_min(pqueue = %SkewHeap{contents: {val, left, right}, cmp_fun: cmp_fun}) do
      result_pqueue = %SkewHeap{pqueue | contents: SkewHeap.combine(left, right, cmp_fun)}
      {:ok, {val, result_pqueue}}
    end

    def peek_min(%SkewHeap{contents: nil}), do: {:error, :empty}
    def peek_min(%SkewHeap{contents: {val, _, _}}), do: {:ok, val}


    def to_list(%SkewHeap{contents: heap1, cmp_fun: cmp_fun}) do
      to_list(heap1, cmp_fun, [])
      |> :lists.reverse
    end

    defp to_list(nil, _cmp_fun, acc), do: acc
    defp to_list({val, left, right}, cmp_fun, acc) do
      res = SkewHeap.combine(left, right, cmp_fun)
      to_list(res, cmp_fun, [val | acc])
    end

    def member?(%SkewHeap{contents: contents, cmp_fun: cmp_fun}, item) do
      member?(contents, item, cmp_fun)
    end

    defp member?(nil, _item, _cmp_fun), do: false
    defp member?({val, left, right}, item, cmp_fun) do
      (cmp_fun.(item, val) == :eq) || member?(left, item, cmp_fun) || member?(right, item, cmp_fun)
    end

    def size(%SkewHeap{contents: contents}) do
      calc_size(contents)
    end

    # TODO Tail recursive using zipper?
    defp calc_size(nil), do: 0
    defp calc_size({_, left, right}), do: 1 + calc_size(left) + calc_size(right)

    def empty?(%SkewHeap{contents: nil}), do: true
    def empty?(%SkewHeap{}), do: false
  end
end
