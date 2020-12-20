defmodule Day17Part2 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> parse_input()
    |> boot(6)
    |> Enum.count()
    |> IO.puts()
  end

  def parse_input(input) do
    {_y, cubes} =
      Enum.reduce(input, {0, MapSet.new()}, fn row, {y, cubes} ->
        {_x, cubes} =
          Enum.reduce(String.graphemes(row), {0, cubes}, fn
            ".", {x, cubes} -> {x + 1, cubes}
            "#", {x, cubes} -> {x + 1, MapSet.put(cubes, {x, y, 0, 0})}
          end)

        {y + 1, cubes}
      end)

    cubes
  end

  def boot(cubes, 0), do: cubes
  def boot(cubes, count), do: boot(cycle(cubes), count - 1)

  def cycle(cubes) do
    {next_cubes, inactives} =
      Enum.reduce(cubes, {MapSet.new(), MapSet.new()}, fn cube, {next_cubes, inactives} ->
        {active_count, inactives} =
          Enum.reduce(neighbours(cube), {0, inactives}, fn neighbour, {active_count, inactives} ->
            if MapSet.member?(cubes, neighbour) do
              {active_count + 1, inactives}
            else
              {active_count, MapSet.put(inactives, neighbour)}
            end
          end)

        next_cubes = if active_count in 2..3, do: MapSet.put(next_cubes, cube), else: next_cubes
        {next_cubes, inactives}
      end)

    Enum.reduce(inactives, next_cubes, fn inactive, next_cubes ->
      active_neighbours =
        inactive |> neighbours() |> MapSet.new() |> MapSet.intersection(cubes) |> Enum.count()

      if active_neighbours == 3, do: MapSet.put(next_cubes, inactive), else: next_cubes
    end)
  end

  def neighbours({x, y, z, w} = me) do
    all =
      for x <- (x - 1)..(x + 1),
          y <- (y - 1)..(y + 1),
          z <- (z - 1)..(z + 1),
          w <- (w - 1)..(w + 1),
          do: {x, y, z, w}

    all -- [me]
  end
end

Day17Part2.run()
