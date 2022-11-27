defmodule DayREPLACE_ME do
  def part1(input) do
    input
  end

  def part2(_input) do
    :ok
  end

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

  def run_parts_with_timer(input) do
    {p1_microsecs, p1_result} = :timer.tc(fn -> part1(input) end)
    IO.puts("Part 1 (completed in #{format_time(p1_microsecs)}):")
    IO.write("\n")
    IO.puts(p1_result)
    IO.write("\n")

    {p2_microsecs, p2_result} = :timer.tc(fn -> part2(input) end)
    IO.puts("Part 2 (completed in #{format_time(p2_microsecs)}):")
    IO.write("\n")
    IO.puts(p2_result)
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec) when μsec < 60_000_000, do: "#{μsec / 1_000_000}s"

  defp format_time(μsec) when μsec < 3_660_000_000 do
    total_secs = round(μsec / 1_000_000)
    mins = div(total_secs, 60)
    secs = rem(total_secs, 60)
    "#{mins}m#{secs}s"
  end

  defp print_usage do
    IO.puts("Usage: elixir dayREPLACE_ME.exs input_filename")
  end
end

# DayREPLACE_ME.run()
