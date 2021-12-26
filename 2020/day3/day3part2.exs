defmodule Day3Part2 do
  def run do
    answer =
      slope(1, 1) *
        slope(3, 1) *
        slope(5, 1) *
        slope(7, 1) *
        slope(1, 2)

    IO.puts(answer)
  end

  def slope(v_x, v_y) do
    {_, trees} =
      File.read!("input")
      |> String.trim()
      |> String.split("\n")
      |> Enum.take_every(v_y)
      |> Enum.map(&String.to_charlist/1)
      |> Enum.reduce({0, 0}, fn row, {x, trees} ->
        trees =
          case Stream.cycle(row) |> Enum.at(x) do
            ?# -> trees + 1
            ?. -> trees
          end

        {x + v_x, trees}
      end)

    trees
  end
end

Day3Part2.run()
