defmodule Day9 do
  defmodule Rope do
    defstruct head: {0, 0},
              tail: {0, 0},
              knots: for(_ <- 1..8, do: {0, 0}),
              visited: MapSet.new([{0, 0}])
  end

  def part1(input) do
    input
    |> Enum.reduce(%Rope{}, &motion/2)
    |> then(fn %Rope{visited: visited} -> MapSet.size(visited) end)
  end

  defp motion({_dir, 0}, rope), do: rope

  defp motion({dir, amount}, rope) do
    head = step_head(rope.head, dir)
    tail = step_tail(head, rope.tail)
    visited = MapSet.put(rope.visited, tail)
    motion({dir, amount - 1}, %Rope{head: head, tail: tail, visited: visited})
  end

  defp step_head({x, y}, "R"), do: {x + 1, y}
  defp step_head({x, y}, "L"), do: {x - 1, y}
  defp step_head({x, y}, "U"), do: {x, y + 1}
  defp step_head({x, y}, "D"), do: {x, y - 1}

  defp step_tail({hx, hy}, {tx, ty}) when abs(hx - tx) <= 1 and abs(hy - ty) <= 1, do: {tx, ty}
  defp step_tail({tx, hy}, {tx, ty}) when hy - ty > 0, do: {tx, ty + 1}
  defp step_tail({tx, hy}, {tx, ty}) when hy - ty < 0, do: {tx, ty - 1}
  defp step_tail({hx, ty}, {tx, ty}) when hx - tx > 0, do: {tx + 1, ty}
  defp step_tail({hx, ty}, {tx, ty}) when hx - tx < 0, do: {tx - 1, ty}

  defp step_tail({hx, hy}, {tx, ty}) do
    dx = if hx - tx > 0, do: 1, else: -1
    dy = if hy - ty > 0, do: 1, else: -1
    {tx + dx, ty + dy}
  end

  def part2(input) do
    input
    |> Enum.reduce(%Rope{}, &motion2/2)
    |> then(fn %Rope{visited: visited} -> MapSet.size(visited) end)
  end

  defp motion2({_dir, 0}, rope), do: rope

  defp motion2({dir, amount}, rope) do
    head = step_head(rope.head, dir)

    {knots, leader} =
      Enum.map_reduce(rope.knots, head, fn knot, leader ->
        new_knot = step_tail(leader, knot)
        {new_knot, new_knot}
      end)

    tail = step_tail(leader, rope.tail)

    visited = MapSet.put(rope.visited, tail)
    motion2({dir, amount - 1}, %Rope{head: head, tail: tail, knots: knots, visited: visited})
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn <<dir::binary-1, " ", amount::binary>> ->
        {dir, String.to_integer(amount)}
      end)
    else
      _ -> :error
    end
  end

  #######################
  # HERE BE BOILERPLATE #
  #######################

  def run do
    case input() do
      :error -> print_usage()
      input -> run_parts_with_timer(input)
    end
  end

  defp run_parts_with_timer(input) do
    run_with_timer(1, fn -> part1(input) end)
    run_with_timer(2, fn -> part2(input) end)
  end

  defp run_with_timer(part, fun) do
    {time, result} = :timer.tc(fun)
    IO.puts("Part #{part} (completed in #{format_time(time)}):\n")
    IO.puts("#{result}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day9.exs input_filename")
  end
end

Day9.run()
