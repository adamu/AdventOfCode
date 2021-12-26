defmodule Day11 do
  @serial 7511
  @size 300

  def hundreds(lvl) when lvl < 100, do: 0

  def hundreds(lvl) do
    [_units, _tens, hundreds | _] = Integer.digits(lvl) |> Enum.reverse()
    hundreds
  end

  def power_level(x, y, serial) do
    rack_id = x + 10
    rack_id |> Kernel.*(y) |> Kernel.+(serial) |> Kernel.*(rack_id) |> hundreds() |> Kernel.-(5)
  end

  def grid(serial \\ @serial) do
    for x <- 1..@size, y <- 1..@size, into: %{} do
      {{x, y}, power_level(x, y, serial)}
    end
  end

  def total_power(x, y, grid) do
    for x <- x..(x + 2), y <- y..(y + 2) do
      grid[{x, y}]
    end
    |> Enum.sum()
  end

  def find_largest_3x3(grid) do
    for x <- 1..(@size - 2), y <- 1..(@size - 2) do
      {{x, y}, total_power(x, y, grid)}
    end
    |> Enum.max_by(fn {_, power} -> power end)
  end

  def part1 do
    {{x, y}, power} = grid() |> find_largest_3x3()
    "#{x},#{y} (total power #{power})"
  end

  # Entry point
  def largest_total_power_at(x, y, grid) do
    size = 1
    power = grid[{x, y}]
    largest_total_power_at(x, y, grid, size, power, size, power)
  end

  # Terminating condition, square size has reached the edge of the grid
  def largest_total_power_at(x, y, _grid, size, _power, max_size, max_power)
      when x + size > @size or y + size > @size do
    {x, y, max_size, max_power}
  end

  # Calculate extra power for square of size + 1 and take the max of the two
  def largest_total_power_at(x, y, grid, size, power, max_size, max_power) do
    new_x = x + size
    new_y = y + size
    new_row = for row_x <- x..new_x, do: grid[{row_x, new_y}]
    # Minus 1 to avoid counting the corner twice
    new_col = for col_y <- y..(new_y - 1), do: grid[{new_x, col_y}]
    new_power = Enum.sum([power | new_row ++ new_col])
    new_size = size + 1

    {max_size, max_power} =
      if new_power > max_power do
        {new_size, new_power}
      else
        {max_size, max_power}
      end

    largest_total_power_at(x, y, grid, new_size, new_power, max_size, max_power)
  end

  # Still very slow, managed to avoid recalculating larger squares, but still recalculates
  # smaller squares that are a subset of a larger square we already calculated.
  # Could fix it, but 300x300 completes in a few mins.. maybe will come back to this
  # I Wonder if replacing all the comprehensions with reduce would have a strong effect
  def part2 do
    grid = grid()

    {x, y, size, power} =
      for x <- 1..@size, IO.inspect(301 - x), y <- 1..@size do
        largest_total_power_at(x, y, grid)
      end
      |> Enum.max_by(fn {_x, _y, _size, power} -> power end)

    "Part 2 Answer: #{x},#{y},#{size} (power: #{power})"
  end
end

IO.puts(Day11.part1())
IO.puts(Day11.part2())
