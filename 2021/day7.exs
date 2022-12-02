defmodule Day7 do
  def part1(input) do
    input
    |> Enum.frequencies()
    |> Enum.into(Map.new(0..Enum.max(input), &{&1, 0}))
    |> calculate_costs()
    |> Enum.min()
  end

  defp calculate_costs(crabs) do
    for here <- Map.keys(crabs) do
      for {there, crabs_there} <- Map.delete(crabs, here), reduce: 0 do
        cost -> cost + abs(here - there) * crabs_there
      end
    end
  end

  def part2(input) do
    input
    |> Enum.frequencies()
    |> Enum.into(Map.new(0..Enum.max(input), &{&1, 0}))
    |> calculate_sum_costs()
    |> Enum.min()
  end

  defp calculate_sum_costs(crabs) do
    for here <- Map.keys(crabs) do
      for {there, crabs_there} <- Map.delete(crabs, here), reduce: 0 do
        cost ->
          distance = abs(here - there)
          # Mmm maths. Can get the sum of 1..n by doing (n * n+1)/2. Guess you have to know it.
          sum = div(distance * (distance + 1), 2)
          cost + sum * crabs_there
      end
    end
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
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
    IO.puts("Usage: elixir day7.exs input_filename")
  end
end

Day7.run()
