defmodule Prioqueue.Implementations.SkewHeap do
  alias __MODULE__

  @moduledoc """
  An implementation of a Priority Queue built on top of a Skew Heap.

  A Skew Heap is very simple, which means that this implementation is
  also quite concise: All operations are built on top of a 'union' procedure.

  To improve efficiency, the internal heap is stored as tuples representing tree nodes
  (rather than structs representing tree nodes)


  More information about Skew Heaps can be found in [Issue #16 of the Monad.Reader](https://themonadreader.files.wordpress.com/2010/05/issue16.pdf).
  """


  # `contents` is either `nil` or `{value, left_tree, right_tree}`
  defstruct contents: nil, cmp_fun: &Kernel.<=/2

  def new do
    %SkewHeap{}
  end

  defimpl Prioqueue.Protocol do
    def insert(pqueue = %SkewHeap{contents: nil}, elem) do
      %SkewHeap{pqueue | contents: {elem, nil, nil}}
    end

    def insert(pqueue = %SkewHeap{contents: pq1, cmp_fun: cmp_fun}, elem) do
      %SkewHeap{pqueue | contents: union(pq1, {elem, nil, nil}, cmp_fun)}
    end

    def extract_min(%SkewHeap{contents: nil}), do: :error
    def extract_min(pqueue = %SkewHeap{contents: {val, left, right}, cmp_fun: cmp_fun}) do
      result_pqueue = %SkewHeap{pqueue | contents: union(left, right, cmp_fun)}
      {:ok, {val, result_pqueue}}
    end

    def to_list(%SkewHeap{contents: pq1, cmp_fun: cmp_fun}) do
      to_list(pq1, cmp_fun, [])
    end

    defp to_list(nil, _cmp_fun, acc), do: acc
    defp to_list({val, left, right}, cmp_fun, acc) do
      res = union(left, right, cmp_fun)
      to_list(res, cmp_fun, [val | acc])
    end

    defp union(pqueue1 = %SkewHeap{contents: pq1, cmp_fun: cmp_fun}, %SkewHeap{contents: pq2}) do
      %SkewHeap{pqueue1 | contents: union(pq1, pq2, cmp_fun)}
    end

    defp union(nil, pq2, _), do: pq2
    defp union(pq1, nil, _), do: pq1
    defp union(pq1 = {x1, l1, r1}, pq2 = {x2, l2, r2}, cmp_fun) do
      if cmp_fun.(x2, x1) do
        {x1, union(pq2, r1, cmp_fun), l1}
      else
        {x2, union(pq1, r2, cmp_fun), l2}
      end
    end
  end
end
