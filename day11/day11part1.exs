defmodule Day11Part1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> parse_seat_plan()
    |> run_until_stable()
    |> elem(2)
    |> count_occupied()
    |> IO.inspect()
  end

  def run_until_stable(state) do
    new_state = tick(state)

    if new_state == state do
      state
    else
      run_until_stable(new_state)
    end
  end

  def tick({width, height, old_seats}) do
    new_seats =
      for(
        x <- 0..(width - 1),
        y <- 0..(height - 1),
        do: {x, y}
      )
      |> Enum.reduce(%{}, fn {x, y}, new_seats ->
        toggle(old_seats[{x, y}], x, y, old_seats, new_seats)
      end)

    {width, height, new_seats}
  end

  def toggle(:empty, x, y, old_seats, new_seats) do
    if occupied_adjacent(x, y, old_seats) == 0 do
      Map.put(new_seats, {x, y}, :occupied)
    else
      Map.put(new_seats, {x, y}, :empty)
    end
  end

  def toggle(:occupied, x, y, old_seats, new_seats) do
    if occupied_adjacent(x, y, old_seats) >= 4 do
      Map.put(new_seats, {x, y}, :empty)
    else
      Map.put(new_seats, {x, y}, :occupied)
    end
  end

  def toggle(:floor, x, y, _, new_seats), do: Map.put(new_seats, {x, y}, :floor)

  def occupied_adjacent(x, y, seats) do
    adjacent = [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]

    seats
    |> Map.take(adjacent)
    |> count_occupied()
  end

  def count_occupied(seats) do
    Enum.count(seats, &match?({_, :occupied}, &1))
  end

  def parse_seat_plan(input) do
    Enum.reduce(input, {0, 0, %{}}, fn row, {_x, y, seats} ->
      {x, seats} =
        Enum.reduce(row, {0, seats}, fn seat, {x, seats} ->
          seat =
            case seat do
              ?L -> :empty
              ?. -> :floor
            end

          {x + 1, Map.put(seats, {x, y}, seat)}
        end)

      {x, y + 1, seats}
    end)
  end

  def visualize({width, height, seats}) do
    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        char =
          case seats[{x, y}] do
            :empty -> "L"
            :floor -> "."
            :occupied -> "#"
          end

        IO.write(char)
      end

      IO.write("\n")
    end
  end
end

Day11Part1.run()
