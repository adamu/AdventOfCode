defmodule Day6 do
  @packet_marker_size 4
  @message_marker_size 14

  def part1(input) do
    find_packet_marker(input)
  end

  defguardp all_different(a, b, c, d)
            when a != b and a != c and a != d and b != c and b != d and c != d

  defp find_packet_marker(buffer, seen \\ @packet_marker_size)
  defp find_packet_marker([a, b, c, d | _rest], seen) when all_different(a, b, c, d), do: seen
  defp find_packet_marker([_skip | rest], seen), do: find_packet_marker(rest, seen + 1)

  def part2(input) do
    find_message_marker(input)
  end

  defp find_message_marker([_skip | rest] = buffer, seen \\ @message_marker_size) do
    window = Enum.take(buffer, @message_marker_size)

    if Enum.uniq(window) == window do
      seen
    else
      find_message_marker(rest, seen + 1)
    end
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> String.codepoints()
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
    IO.puts("Usage: elixir day6.exs input_filename")
  end
end

Day6.run()
