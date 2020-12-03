defmodule Day3Part1 do
  def run do
    {x, y, trees} =
      File.read!("input")
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_charlist/1)
      |> Enum.reduce({0, 0, 0}, fn row, {x, y, trees} ->
        trees =
          case Stream.cycle(row) |> Enum.at(x) do
            ?# -> trees + 1
            ?. -> trees
          end

        {x + 3, y + 1, trees}
      end)

    IO.puts("Travelled (#{x}, #{y}) and encountereed #{trees} trees")
  end
end

Day3Part1.run()
