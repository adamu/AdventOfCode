defmodule Day4 do
  def part1(input) do
    input
    |> Enum.map(fn {_id, winning, have} ->
      case MapSet.intersection(winning, have) |> MapSet.size() do
        0 -> 0
        num_winners -> 2 ** (num_winners - 1)
      end
    end)
    |> Enum.sum()
  end

  def part2(_input) do
    :ok
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [card_id, winning, have] = String.split(line, [": ", " | "])
        ["Card", id] = String.split(card_id, " ", trim: true)

        [winning, have] =
          for cards <- [winning, have],
              do: cards |> String.split(" ", trim: true) |> MapSet.new(&String.to_integer/1)

        {String.to_integer(id), winning, have}
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
    IO.puts("#{inspect(result)}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day4.exs input_filename")
  end
end

# Day4.run()
