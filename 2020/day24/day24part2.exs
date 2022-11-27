defmodule Cell do
  defstruct [:x, :y]
end

defmodule Day24Part2 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(MapSet.new(), fn cell, black ->
      if MapSet.member?(black, cell) do
        MapSet.delete(black, cell)
      else
        MapSet.put(black, cell)
      end
    end)
    |> flip_times(100)
    |> Enum.count()
    |> IO.puts()
  end

  def parse_line(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_while(
      nil,
      fn
        "n", nil -> {:cont, :north}
        "s", nil -> {:cont, :south}
        "e", :north -> {:cont, :northeast, nil}
        "e", :south -> {:cont, :southeast, nil}
        "e", nil -> {:cont, :east, nil}
        "w", :north -> {:cont, :northwest, nil}
        "w", :south -> {:cont, :southwest, nil}
        "w", nil -> {:cont, :west, nil}
      end,
      fn acc -> {:cont, acc} end
    )
    |> Enum.reduce(%Cell{x: 0, y: 0}, &move/2)
  end

  def move(:east, %Cell{x: x, y: y}), do: %Cell{x: x + 2, y: y}
  def move(:west, %Cell{x: x, y: y}), do: %Cell{x: x - 2, y: y}
  def move(:northeast, %Cell{x: x, y: y}), do: %Cell{x: x + 1, y: y + 1}
  def move(:northwest, %Cell{x: x, y: y}), do: %Cell{x: x - 1, y: y + 1}
  def move(:southeast, %Cell{x: x, y: y}), do: %Cell{x: x + 1, y: y - 1}
  def move(:southwest, %Cell{x: x, y: y}), do: %Cell{x: x - 1, y: y - 1}

  # Below code adapted from Day 17 Part 2

  def flip_times(cells, 0), do: cells
  def flip_times(cells, count), do: flip_times(flip(cells), count - 1)

  def flip(cells) do
    {flipped, whites} =
      Enum.reduce(cells, {MapSet.new(), MapSet.new()}, fn cell, {flipped, whites} ->
        {black_count, whites} =
          Enum.reduce(neighbours(cell), {0, whites}, fn neighbour, {black_count, whites} ->
            if MapSet.member?(cells, neighbour) do
              {black_count + 1, whites}
            else
              {black_count, MapSet.put(whites, neighbour)}
            end
          end)

        flipped =
          if black_count == 0 or black_count > 2,
            do: flipped,
            else: MapSet.put(flipped, cell)

        {flipped, whites}
      end)

    Enum.reduce(whites, flipped, fn white, flipped ->
      black_neighbours =
        white |> neighbours() |> MapSet.new() |> MapSet.intersection(cells) |> Enum.count()

      if black_neighbours == 2, do: MapSet.put(flipped, white), else: flipped
    end)
  end

  def neighbours(cell) do
    [:east, :west, :northeast, :northwest, :southeast, :southwest]
    |> Enum.map(&move(&1, cell))
  end
end

Day24Part2.run()
