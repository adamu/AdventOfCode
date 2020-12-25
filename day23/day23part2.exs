defmodule Day23Part2 do
  @input "137826495"
  def run do
    {a, b} =
      @input
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> init_cups()
      |> play(10_000_000)
      |> next_two_after_1()

    IO.puts("Next two cups: #{a}, #{b}")
    IO.puts("Answer: #{a * b}")
  end

  def init_cups([first, second | _] = input) do
    cups = :ets.new(:circle, [])

    (input ++ for(i <- 10..1_000_000, do: i))
    |> Stream.chunk_every(3, 1)
    |> Stream.each(fn
      [a, b, c] ->
        :ets.insert(cups, {b, {a, c}})

      [penultimate, last] ->
        :ets.insert(cups, {first, {last, second}})
        :ets.insert(cups, {last, {penultimate, first}})
    end)
    |> Stream.run()

    {first, cups}
  end

  def play({_current, cups}, 0), do: cups
  def play(state, times), do: move(state) |> play(times - 1)

  def move({current, cups}) do
    holding = take_three(cups, current)
    dest = find_dest(holding, current)
    cups = insert(holding, dest, cups)
    [{^current, {_prev, next}}] = :ets.lookup(cups, current)

    {next, cups}
  end

  def find_dest(holding, 1), do: find_dest(holding, 1_000_001)

  def find_dest(holding, current) do
    dest = current - 1
    if dest in holding, do: find_dest(holding, dest), else: dest
  end

  def take_three(cups, current) do
    [{^current, {prev, a}}] = :ets.lookup(cups, current)
    [{^a, {^current, b}}] = :ets.lookup(cups, a)
    [{^b, {^a, c}}] = :ets.lookup(cups, b)
    [{^c, {^b, next}}] = :ets.lookup(cups, c)
    [{^next, {^c, last}}] = :ets.lookup(cups, next)
    :ets.insert(cups, {current, {prev, next}})
    :ets.insert(cups, {next, {current, last}})
    [a, b, c]
  end

  def insert([a, b, c], dest, cups) do
    [{^dest, {prev, next}}] = :ets.lookup(cups, dest)
    [{^next, {^dest, last}}] = :ets.lookup(cups, next)
    :ets.insert(cups, {dest, {prev, a}})
    :ets.insert(cups, {a, {dest, b}})
    :ets.insert(cups, {c, {b, next}})
    :ets.insert(cups, {next, {c, last}})
    cups
  end

  def next_two_after_1(cups) do
    [{1, {_prev, next}}] = :ets.lookup(cups, 1)
    [{^next, {1, nextnext}}] = :ets.lookup(cups, next)
    {next, nextnext}
  end
end

Day23Part2.run()
