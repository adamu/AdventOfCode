defmodule Day8 do
  def part1({instructions, network}) do
    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({"AAA", 0}, fn
      _side, {"ZZZ", count} -> {:halt, count}
      side, {node, count} -> {:cont, {elem(network[node], side), count + 1}}
    end)
  end

  # Runs forever.
  # Need a better answer. Start at the end and validate can get there or something?
  def part2({instructions, network}) do
    starting_nodes =
      network
      |> Map.keys()
      |> Enum.filter(&match?(<<_::binary-2, "A">>, &1))

    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({starting_nodes, 0}, fn side, {current_nodes, count} ->
      if Enum.all?(current_nodes, &match?(<<_::binary-2, "Z">>, &1)) do
        {:halt, count}
      else
        next_nodes = Enum.map(current_nodes, fn node -> elem(network[node], side) end)
        {:cont, {next_nodes, count + 1}}
      end
    end)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      [instructions, nodes] = String.split(input, "\n\n")

      instructions =
        instructions
        |> String.graphemes()
        |> Enum.map(fn
          "L" -> 0
          "R" -> 1
        end)

      network =
        for <<key::binary-3, " = (", left::binary-3, ", ", right::binary-3, ")\n" <- nodes>>,
          into: %{},
          do: {key, {left, right}}

      {instructions, network}
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
    IO.puts("Usage: elixir day8.exs input_filename")
  end
end

Day8.run()
