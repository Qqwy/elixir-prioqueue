for module <- [
      Prioqueue.Implementations.SkewHeap
    ] do

    defimpl Inspect, for: module do
      import Inspect.Algebra

      def inspect(prioqueue, _opts) do
        concat ["##{inspect(@for)}<", inspect(Prioqueue.Protocol.to_list(prioqueue)) ,">"]
      end
    end
end
