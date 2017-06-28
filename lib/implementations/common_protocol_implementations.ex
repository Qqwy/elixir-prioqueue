# This file contains common protocol implementations
# that can be defined for multiple Prioqueue implementation structures at once.

for module <- [
      Prioqueue.Implementations.SkewHeap
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
        Prioqueue.Protocol.insert(prioqueue, elem)
      end
    end
end
