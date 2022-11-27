defmodule Day23Part1 do
  # @input "389125467"
  @input "137826495"
  def run do
    @input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> play(100)
    |> cycle_to(1)
    |> Enum.drop(1)
    |> Enum.join()
    |> IO.puts()
  end

  def play(cups, 0), do: cups
  def play(cups, times), do: move(cups) |> play(times - 1)

  def move([current, a, b, c | rest]) do
    holding = [a, b, c]
    dest = find_dest(current, holding)

    insert(holding, dest, [current | rest])
    |> cycle_to(current, 1)
  end

  def find_dest(1, holding), do: find_dest(10, holding)

  def find_dest(current, holding) do
    dest = current - 1
    if dest in holding, do: find_dest(dest, holding), else: dest
  end

  def insert(holding, dest, circle) do
    [dest | rest] = cycle_to(circle, dest)
    [dest | holding] ++ rest
  end

  def cycle_to(circle, target, offset \\ 0) do
    circle
    |> Stream.cycle()
    |> Stream.drop_while(&(&1 != target))
    |> Stream.take(length(circle) + offset)
    |> Enum.drop(offset)
  end
end

Day23Part1.run()
