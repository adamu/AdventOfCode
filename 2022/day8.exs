defmodule Day8 do
  defmodule Tree do
    defstruct height: nil, visible: false, score: []
  end

  def part1({{max_x, max_y}, trees}) do
    trees
    |> look_in_direction(0..max_y, 0..max_x, false)
    |> look_in_direction(0..max_x, 0..max_y, true)
    |> look_in_direction(0..max_y, max_x..0, false)
    |> look_in_direction(0..max_x, max_y..0, true)
    |> Enum.count(&match?({_coord, %Tree{visible: true}}, &1))
  end

  defp look_in_direction(trees, outer_range, inner_range, flip_xy?) do
    Enum.reduce(outer_range, trees, fn y, trees ->
      {_height, trees} =
        Enum.reduce_while(inner_range, {_height = -1, trees}, fn
          _x, {9, trees} ->
            {:halt, {9, trees}}

          x, {height, trees} ->
            coord = if flip_xy?, do: {y, x}, else: {x, y}
            tree = trees[coord]

            if tree.height > height do
              {:cont, {tree.height, Map.replace(trees, coord, %Tree{tree | visible: true})}}
            else
              {:cont, {height, trees}}
            end
        end)

      trees
    end)
  end

  def part2({{max_x, max_y}, trees}) do
    trees
    |> count_viewing_distance(0..max_y, 0..max_x, false)
    |> count_viewing_distance(0..max_x, 0..max_y, true)
    |> count_viewing_distance(0..max_y, max_x..0, false)
    |> count_viewing_distance(0..max_x, max_y..0, true)
    |> Enum.map(fn {_coord, %Tree{score: score}} -> Enum.reduce(score, &Kernel.*/2) end)
    |> Enum.max()
  end

  defp count_viewing_distance(trees, outer_range, inner_range, flip_xy?) do
    Enum.reduce(outer_range, trees, fn y, trees ->
      {_scoring, trees} =
        Enum.reduce(inner_range, {_scoring = [], trees}, fn
          x, {scoring, trees} ->
            coord = if flip_xy?, do: {y, x}, else: {x, y}
            tree = trees[coord]

            {scoring, trees} =
              Enum.reduce(scoring, {[], trees}, fn {coord, scoring_tree}, {scoring, trees} ->
                %Tree{score: [score | scores]} = scoring_tree
                scoring_tree = %Tree{scoring_tree | score: [score + 1 | scores]}
                trees = Map.replace(trees, coord, scoring_tree)

                if scoring_tree.height <= tree.height do
                  {scoring, trees}
                else
                  {[{coord, scoring_tree} | scoring], trees}
                end
              end)

            tree = %Tree{tree | score: [0 | tree.score]}
            {[{coord, tree} | scoring], Map.replace(trees, coord, tree)}
        end)

      trees
    end)
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      grid =
        input
        |> String.trim()
        |> String.split("\n")
        |> Enum.map(&String.graphemes/1)

      max_x = length(hd(grid)) - 1
      max_y = length(grid) - 1

      trees =
        for {row, y} <- Enum.with_index(grid), {height, x} <- Enum.with_index(row), into: %{} do
          {{x, y}, %Tree{height: String.to_integer(height)}}
        end

      {{max_x, max_y}, trees}
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
