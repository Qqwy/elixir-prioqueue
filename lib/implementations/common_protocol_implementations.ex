# This file contains common protocol implementations
# that can be defined for multiple Prioqueue implementation structures at once.

for module <- [
      Prioqueue.Implementations.SkewHeap,
      Prioqueue.Implementations.PairingHeap
    ] do

    defimpl Inspect, for: module do
      import Inspect.Algebra

      def inspect(prioqueue, _opts) do
        concat ["##{inspect(@for)}<", inspect(Prioqueue.Protocol.to_list(prioqueue)) ,">"]
      end
    end

    defimpl Extractable, for: module do
      def extract(prioqueue) do
        Prioqueue.Protocol.extract_min(prioqueue)
      end
    end

    defimpl Insertable, for: module do
      def insert(prioqueue, elem) do
        {:ok, Prioqueue.Protocol.insert(prioqueue, elem)}
      end
    end

    defimpl Collectable, for: module do
      def into(original) do
        {original, fn
          prioqueue, {:cont, value} -> Prioqueue.Protocol.insert(prioqueue, value)
          prioqueue, :done -> prioqueue
          _, :halt -> :ok
        end}
      end
    end

    defimpl Enumerable, for: module do
      def reduce(_, {:halt, acc}, _fun) do
        {:halted, acc}
      end

      def reduce(prioqueue, {:suspend, acc}, fun) do
        {:suspended, acc, &reduce(prioqueue, &1, fun)}
      end

      def reduce(prioqueue, {:cont, acc}, fun) do
        case Prioqueue.Protocol.extract_min(prioqueue) do
          {:ok, {item, prioqueue}} ->
            reduce(prioqueue, fun.(item, acc), fun)
          {:error, :empty} ->
            {:done, acc}
        end
      end

      def member?(prioqueue, item) do
        Prioqueue.Protocol.member?(prioqueue, item)
      end

      def count(prioqueue) do
        {:ok, Prioqueue.Protocol.size(prioqueue)}
      end
    end
end
