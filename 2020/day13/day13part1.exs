defmodule Day13Part1 do
  def run do
    File.read!("input")
    |> String.split(["\n", ","], trim: true)
    |> Enum.reject(&(&1 == "x"))
    |> Enum.map(&String.to_integer/1)
    |> earliest_bus()
    |> (fn {id, time} -> id * time end).()
    |> IO.puts()
  end

  def earliest_bus([now | busses]) do
    busses
    |> Enum.map(fn bus -> {bus, bus - rem(now, bus)} end)
    |> Enum.min(fn {_, time1}, {_, time2} -> time1 <= time2 end)
  end
end

Day13Part1.run()
