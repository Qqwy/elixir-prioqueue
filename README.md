# Prioqueue

[![hex.pm version](https://img.shields.io/hexpm/v/prioqueue.svg)](https://hex.pm/packages/prioqueue)
[![Build Status](https://travis-ci.org/Qqwy/elixir-prioqueue.svg?branch=master)](https://travis-ci.org/Qqwy/elixir-prioqueue)

Prioqueue contains well-structured priority queues for Elixir:

- A single, public interface.
- Multiple implementations with difference performance properties. Decide the best one later on in your configuration settings, after building your application!


## Examples

```elixir
iex> pqueue = (
iex> Prioqueue.empty()
iex> |> Prioqueue.insert(10)
iex> |> Prioqueue.insert(20)
iex> |> Prioqueue.insert(15)
iex> |> Prioqueue.insert(100)
iex> )
#Prioqueue.Implementations.SkewHeap<[10, 15, 20, 100]>
iex> Prioqueue.member?(pqueue, 20)
true
iex> {:ok, {item, pqueue_rest}} = Prioqueue.extract_min(pqueue)
iex> item
10
iex> pqueue_rest
#Prioqueue.Implementations.SkewHeap<[15, 20, 100]>
```

## Protocols

```elixir
iex> pqueue = Enum.into([1, 2, 3, 10, 5, 2], Prioqueue.new())
#Prioqueue.Implementations.SkewHeap<[1, 2, 2, 3, 5, 10]>
iex> Enum.map(pqueue, fn x -> x * 2 end)
[2, 4, 4, 6, 10, 20]
```

## Configuration settings

The behaviour of Prioqueue can be altered per call by passing options to `new`, or by writing down application-wide configuration options for the application `:prioqueue`:

- `:default_implementation`: The Priority Queue implementation to use.
- `:default_comparison_function`: The comparison function that should be used to keep the Priority Queue ordered.

## Available Implementations

- **SkewHeap** (The default): Relatively efficient, simple implementation, amortized running time.
- **PairingHeap**: Very efficient, amortized running time.

Planned are:

- Binomial Heap (quite efficient, real-time)

## Installation

The package can be installed
by adding `prioqueue` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:prioqueue, "~> 0.2.0"}
  ]
end
```

The docs can
be found at [https://hexdocs.pm/prioqueue](https://hexdocs.pm/prioqueue).

## Changelog

- 0.2.6 Fix Enumerable implementation of `member?/2`.
- 0.2.5 Improving Inspect.
- 0.2 Implementation of new Extractable and Insertable protocols.
