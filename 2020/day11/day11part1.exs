defmodule Day11Part1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> parse_seat_plan()
    |> run_until_stable()
    |> count_occupied()
    |> IO.inspect()
  end

  def run_until_stable(seats) do
    new_seats = tick(seats)

    if new_seats == seats do
      seats
    else
      run_until_stable(new_seats)
    end
  end

  def tick(seats) do
    Map.new(seats, fn {{x, y}, old_seat} -> toggle(old_seat, x, y, seats) end)
  end

  def toggle(:empty, x, y, seats) do
    new_value =
      if occupied_adjacent(x, y, seats) == 0 do
        :occupied
      else
        :empty
      end

    {{x, y}, new_value}
  end

  def toggle(:occupied, x, y, seats) do
    new_value =
      if occupied_adjacent(x, y, seats) >= 4 do
        :empty
      else
        :occupied
      end

    {{x, y}, new_value}
  end

  def toggle(:floor, x, y, _), do: {{x, y}, :floor}

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
    {_, seats} =
      Enum.reduce(input, {0, %{}}, fn row, {y, seats} ->
        {_, seats} =
          Enum.reduce(row, {0, seats}, fn seat, {x, seats} ->
            seat =
              case seat do
                ?L -> :empty
                ?. -> :floor
                ?# -> :occupied
              end

            {x + 1, Map.put(seats, {x, y}, seat)}
          end)

        {y + 1, seats}
      end)

    seats
  end
end

Day11Part1.run()
