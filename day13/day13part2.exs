defmodule Day13Part2 do
  def run do
    schedule =
      File.read!("input")
      |> String.split(["\n", ","], trim: true)
      |> Enum.drop(1)
      |> Enum.map(&parse_schedule/1)
      |> Enum.with_index()
      |> Enum.reject(&match?({:any, _}, &1))
      |> IO.inspect()

    {max_id, max_offset} =
      Enum.max(schedule, fn {id1, _}, {id2, _} -> id1 >= id2 end)
      |> IO.inspect()

    start_time =
      Enum.reduce(schedule, 1, fn {id, _}, acc -> id * acc end)
      |> Kernel.-(max_offset)
      |> IO.inspect(label: "start time")

    find_sequential_departures(start_time, schedule, max_id)
    |> IO.inspect()
  end

  def parse_schedule(id) do
    case Integer.parse(id) do
      {id, ""} -> id
      _ -> :any
    end
  end

  def find_sequential_departures(t, busses, period) do
    if Enum.all?(busses, fn {id, offset} -> departs_at_offset?(t, id, offset) end) do
      t
    else
      find_sequential_departures(t - period, busses, period)
    end
  end

  def departs_at_offset?(t, id, offset), do: rem(t + offset, id) == 0
end

Day13Part2.run()
