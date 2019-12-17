defmodule PrioqueueTest do
  use ExUnit.Case
  doctest Prioqueue

  test "default arguments" do
    assert Prioqueue.empty() == Prioqueue.Implementations.SkewHeap.empty([])
  end

  for impl <- [
    Prioqueue.Implementations.PairingHeap,
    Prioqueue.Implementations.SkewHeap,
  ] do

    test "#{impl} creation and list" do
      prioqueue = Prioqueue.empty(implementation: unquote(impl))
      assert Prioqueue.to_list(prioqueue) == []
    end

    test "#{impl} to_list" do
      assert Prioqueue.to_list(simple_prioqueue(unquote(impl))) == [1,2,3,4]
    end

    test "#{impl} insert" do
      prioqueue =
        Prioqueue.empty(implementation: unquote(impl))
        |> Prioqueue.insert(42)

      assert Prioqueue.to_list(prioqueue) == [42]
    end

    test "#{impl} extract_min" do
      prioqueue = Prioqueue.empty(implementation: unquote(impl))
      assert Prioqueue.extract_min(prioqueue) == {:error, :empty}

      prioqueue = simple_prioqueue(unquote(impl))
      {:ok, {item, prioqueue}} = Prioqueue.extract_min(prioqueue)
      assert item == 1
      {:ok, {item, prioqueue}} = Prioqueue.extract_min(prioqueue)
      assert item == 2
      {:ok, {item, prioqueue}} = Prioqueue.extract_min(prioqueue)
      assert item == 3
      {:ok, {item, prioqueue}} = Prioqueue.extract_min(prioqueue)
      assert item == 4

      assert Prioqueue.extract_min(prioqueue) == {:error, :empty}
    end

    test "#{impl} size" do
      assert simple_prioqueue(unquote(impl)) |> Prioqueue.size == 4
    end

    test "#{impl} empty?" do
      assert prioqueue = Prioqueue.empty(implementation: unquote(impl))
      assert Prioqueue.empty?(prioqueue)
      refute (simple_prioqueue(unquote(impl)) |> Prioqueue.empty?)
    end

    test "#{impl} member?" do
      prioqueue = Prioqueue.empty(implementation: unquote(impl))
      refute Prioqueue.member?(prioqueue, 1)
      assert (simple_prioqueue(unquote(impl)) |> Prioqueue.member?(1))
    end

    test "#{impl} :default_comparison_function?" do
      # temporarily set the cmp_inverse in the application
      Application.put_env(:prioqueue, :default_comparison_function, &Prioqueue.Helper.cmp_inverse/2)

      pqueue_inverse_app = Enum.into([1, 3, 2], Prioqueue.empty(implementation: unquote(impl)))

      # restore the default
      Application.put_env(:prioqueue, :default_comparison_function, &Prioqueue.Helper.cmp/2)

      assert Enum.map(pqueue_inverse_app,fn x -> x end) == [3, 2, 1]
    end

    test "#{impl} cmp_fun?" do
      pqueue_inverse = Enum.into([1, 3, 2], Prioqueue.empty(implementation: unquote(impl), cmp_fun: &Prioqueue.Helper.cmp_inverse/2))
      assert Enum.map(pqueue_inverse,fn x -> x end) == [3, 2, 1]
    end

  end
  def simple_prioqueue(impl) do
    Prioqueue.empty(implementation: impl)
    |> Prioqueue.insert(1)
    |> Prioqueue.insert(3)
    |> Prioqueue.insert(2)
    |> Prioqueue.insert(4)
  end
end
