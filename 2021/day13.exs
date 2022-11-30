defmodule Day13 do
  defmodule Paper do
    defstruct dots: MapSet.new(), instructions: []
  end

  def part1(paper) do
    folded = fold(paper)
    MapSet.size(folded.dots)
  end

  defp fold(%Paper{dots: dots, instructions: [{axis, pos} | rest]}) do
    dots =
      MapSet.new(dots, fn {x, y} ->
        cond do
          axis == "x" and x > pos -> {pos - (x - pos), y}
          axis == "y" and y > pos -> {x, pos - (y - pos)}
          true -> {x, y}
        end
      end)

    %Paper{dots: dots, instructions: rest}
  end

  def part2(paper) do
    paper
    |> fold_all
    |> draw
  end

  defp fold_all(%Paper{instructions: []} = paper), do: paper
  defp fold_all(%Paper{} = paper), do: paper |> fold |> fold_all

  defp draw(paper) do
    {max_x, max_y} =
      for {x, y} <- paper.dots, reduce: {0, 0} do
        {max_x, max_y} -> {max(x, max_x), max(y, max_y)}
      end

    for y <- 0..max_y do
      row =
        for x <- 0..max_x do
          if MapSet.member?(paper.dots, {x, y}), do: ?#, else: ?\s
        end

      # could Enum.join("\n") here, but I want to play with iolists
      [row | "\n"]
    end
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      [dots, instructions] = String.split(input, "\n\n")

      dots =
        dots
        |> String.split([",", "\n"])
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)
        |> MapSet.new(fn [x, y] -> {x, y} end)

      instructions =
        instructions
        |> String.split("\n", trim: true)
        |> Enum.map(fn <<"fold along ", axis::binary-1, "=", pos::binary>> ->
          {axis, String.to_integer(pos)}
        end)

      %Paper{dots: dots, instructions: instructions}
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
    IO.puts("Usage: elixir day13.exs input_filename")
  end
end

Day13.run()
