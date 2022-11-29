defmodule Day9 do
  defmodule Cave do
    defstruct floor: %{}, max_x: 0, max_y: 0
  end

  def part1(cave) do
    for x <- 0..cave.max_x, y <- 0..cave.max_y, lowest_neighbour?(cave, x, y), reduce: 0 do
      risk_level -> risk_level + cave.floor[{x, y}] + 1
    end
  end

  defp neighbours(cave, x, y) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.reject(fn {x, y} -> x < 0 or x > cave.max_x or y < 0 or y > cave.max_y end)
  end

  defp lowest_neighbour?(cave, x, y) do
    here = cave.floor[{x, y}]
    Enum.all?(neighbours(cave, x, y), fn {xn, yn} -> here < cave.floor[{xn, yn}] end)
  end

  def part2(cave) do
    cave
    |> remove_nines()
    |> find_basins()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp find_basins(%Cave{floor: floor}) when floor == %{}, do: []

  defp find_basins(cave) do
    {cave, location} = get_start_location(cave)
    {cave, basin} = find_basin(cave, [location], [location])
    [basin | find_basins(cave)]
  end

  defp find_basin(cave, [], basin), do: {cave, length(basin)}

  defp find_basin(cave, [{x, y} | locations], basin) do
    neighbours = cave.floor |> Map.take(neighbours(cave, x, y)) |> Map.keys()
    cave = %Cave{cave | floor: Map.drop(cave.floor, neighbours)}
    find_basin(cave, locations ++ neighbours, basin ++ neighbours)
  end

  defp remove_nines(cave) do
    floor = Map.reject(cave.floor, &match?({_k, 9}, &1))
    %Cave{cave | floor: floor}
  end

  defp get_start_location(cave) do
    [{location, _v}] = Enum.take(cave.floor, 1)
    cave = %Cave{cave | floor: Map.delete(cave.floor, location)}
    {cave, location}
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      rows =
        input
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, "", trim: true))

      floor =
        for {row, y} <- Enum.with_index(rows), {height, x} <- Enum.with_index(row), into: %{} do
          {{x, y}, String.to_integer(height)}
        end

      max_x = length(hd(rows)) - 1
      max_y = length(rows) - 1

      %Cave{floor: floor, max_x: max_x, max_y: max_y}
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
