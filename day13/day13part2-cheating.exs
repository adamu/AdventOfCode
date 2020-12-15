defmodule Day13Part2 do
  def run do
    File.read!("input")
    |> String.split(["\n", ","], trim: true)
    |> Enum.drop(1)
    |> Enum.map(&parse_schedule/1)
    |> Enum.with_index()
    |> Enum.reject(&match?({:any, _}, &1))
    |> Enum.reduce({0, 1}, &find_sequential_departures/2)
    |> elem(0)
    |> IO.puts()
  end

  def parse_schedule(id) do
    case Integer.parse(id) do
      {id, ""} -> id
      _ -> :any
    end
  end

  # Adapted from voltone's solution ❤️
  # https://elixirforum.com/t/advent-of-code-2020-day-13/36180/6
  defp find_sequential_departures({bus, index}, {t, step}) do
    if rem(t + index, bus) == 0 do
      {t, lcm(step, bus)}
    else
      find_sequential_departures({bus, index}, {t + step, step})
    end
  end

  defp lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end
end

Day13Part2.run()
