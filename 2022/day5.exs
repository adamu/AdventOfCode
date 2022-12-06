defmodule Day5 do
  def part1(input), do: input |> move_with(&move_9000/3) |> top_crates()
  def part2(input), do: input |> move_with(&move_9001/3) |> top_crates()

  defp move_with({stacks, procedure}, move) do
    for [number, from_index, to_index] <- procedure, reduce: stacks do
      stacks ->
        {moved_from, moved_to} = move.(number, stacks[from_index], stacks[to_index])
        %{stacks | from_index => moved_from, to_index => moved_to}
    end
  end

  defp move_9000(0, from, to), do: {from, to}
  defp move_9000(number, [crate | from], to), do: move_9000(number - 1, from, [crate | to])

  defp move_9001(number, from, to) do
    {moving, moved_from} = Enum.split(from, number)
    {moved_from, moving ++ to}
  end

  defp top_crates(stacks) do
    stacks
    |> Enum.sort_by(fn {label, _stack} -> label end)
    |> Enum.reduce("", fn {_label, [top | _stack]}, acc -> acc <> top end)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      [raw_stacks, raw_procedure] = String.split(input, "\n\n")

      stacks =
        raw_stacks
        |> String.split("\n")
        |> parse_stacks()
        |> Enum.zip()
        |> Enum.map(fn stack -> stack |> Tuple.to_list() |> Enum.drop_while(&is_nil/1) end)
        |> Enum.with_index()
        |> Map.new(fn {stack, index} -> {index + 1, stack} end)

      procedure =
        raw_procedure
        |> String.split(["move ", " from ", " to ", "\n"], trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(3)

      {stacks, procedure}
    else
      _ -> :error
    end
  end

  defp parse_stacks([_labels_]), do: []
  defp parse_stacks([line | rest]), do: [parse_line(line) | parse_stacks(rest)]

  defp parse_line(<<"">>), do: []
  defp parse_line(<<"    ", rest::binary>>), do: [nil | parse_line(rest)]
  defp parse_line(<<"[", crate::binary-1, "]", rest::binary>>), do: [crate | parse_line(rest)]
  defp parse_line(<<" ", rest::binary>>), do: parse_line(rest)

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
