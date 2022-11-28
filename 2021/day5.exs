defmodule Day5 do
  def part1(input) do
    input
    |> Enum.reduce(_points = %{}, fn
      {{x, y1}, {x, y2}}, points ->
        for y <- y1..y2, reduce: points, do: (points -> plot(points, {x, y}))

      {{x1, y}, {x2, y}}, points ->
        for x <- x1..x2, reduce: points, do: (points -> plot(points, {x, y}))

      _point, points ->
        points
    end)
    |> Enum.count(fn {_point, count} -> count >= 2 end)
  end

  def part2(input) do
    input
    |> Enum.reduce(_points = %{}, fn
      {{x, y1}, {x, y2}}, points ->
        for y <- y1..y2, reduce: points, do: (points -> plot(points, {x, y}))

      {{x1, y}, {x2, y}}, points ->
        for x <- x1..x2, reduce: points, do: (points -> plot(points, {x, y}))

      {{x1, x1}, {x2, x2}}, points ->
        for x <- x1..x2, reduce: points, do: (points -> plot(points, {x, x}))

      {{x1, y1}, {x2, y2}}, points ->
        for point <- Enum.zip(x1..x2, y1..y2), reduce: points, do: (points -> plot(points, point))
    end)
    |> Enum.count(fn {_point, count} -> count >= 2 end)
  end

  defp plot(points, point) do
    Map.put(points, point, (points[point] || 0) + 1)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split(["\n", " -> ", ","], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(4)
      |> Enum.map(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)
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
    IO.puts("Usage: elixir day5.exs input_filename")
  end
end

Day5.run()
