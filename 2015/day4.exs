defmodule Day4 do
  def part1(input), do: mine(input, 1, "00000")

  def mine(input, nonce, prefix) do
    hash = :crypto.hash(:md5, input <> Integer.to_string(nonce)) |> Base.encode16()
    if String.starts_with?(hash, prefix), do: nonce, else: mine(input, nonce + 1, prefix)
  end

  def part2(input), do: mine(input, 1, "000000")

  def input do
    with [input] <- System.argv() do
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
    IO.puts("Usage: elixir day4.exs input")
  end
end

Day4.run()
