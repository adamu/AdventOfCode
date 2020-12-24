defmodule Cell do
  defstruct [:x, :y]
end

defmodule Day24Part1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&to_cell/1)
    |> Enum.reduce(MapSet.new(), fn cell, black ->
      if MapSet.member?(black, cell) do
        MapSet.delete(black, cell)
      else
        MapSet.put(black, cell)
      end
    end)
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
  end

  def to_cell(directions) do
    Enum.reduce(directions, %Cell{x: 0, y: 0}, &move/2)
  end

  def move(:east, %Cell{x: x, y: y}), do: %Cell{x: x + 2, y: y}
  def move(:west, %Cell{x: x, y: y}), do: %Cell{x: x - 2, y: y}
  def move(:northeast, %Cell{x: x, y: y}), do: %Cell{x: x + 1, y: y + 1}
  def move(:northwest, %Cell{x: x, y: y}), do: %Cell{x: x - 1, y: y + 1}
  def move(:southeast, %Cell{x: x, y: y}), do: %Cell{x: x + 1, y: y - 1}
  def move(:southwest, %Cell{x: x, y: y}), do: %Cell{x: x - 1, y: y - 1}
end

Day24Part1.run()
