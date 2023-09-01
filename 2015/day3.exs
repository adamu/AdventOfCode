defmodule Day3 do
  def part1(input), do: move(input, MapSet.new([{0, 0}]), {0, 0})

  def move(<<?<, rest::binary>>, houses, {x, y}), do: deliver(rest, houses, {x - 1, y})
  def move(<<?>, rest::binary>>, houses, {x, y}), do: deliver(rest, houses, {x + 1, y})
  def move(<<?^, rest::binary>>, houses, {x, y}), do: deliver(rest, houses, {x, y - 1})
  def move(<<?v, rest::binary>>, houses, {x, y}), do: deliver(rest, houses, {x, y + 1})
  def move(<<>>, houses, _addr), do: MapSet.size(houses)

  def deliver(moves, houses, addr), do: move(moves, MapSet.put(houses, addr), addr)

  def part2(input), do: move2(input, MapSet.new([{0, 0}]), {0, 0}, {0, 0})

  def move2(<<ms, mb, rest::binary>>, houses, santa, bot) do
    santa = next(ms, santa)
    bot = next(mb, bot)
    move2(rest, MapSet.union(houses, MapSet.new([santa, bot])), santa, bot)
  end

  def move2(<<>>, houses, _santa, _bot), do: MapSet.size(houses)

  def next(?<, {x, y}), do: {x - 1, y}
  def next(?>, {x, y}), do: {x + 1, y}
  def next(?^, {x, y}), do: {x, y - 1}
  def next(?v, {x, y}), do: {x, y + 1}

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
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
    IO.puts("Usage: elixir day3.exs input_filename")
  end
end

Day3.run()
