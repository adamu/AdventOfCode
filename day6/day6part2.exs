defmodule Day6Part2 do
  def run do
    File.stream!("input")
    |> Stream.chunk_by(&(&1 == "\n"))
    |> Stream.map(fn group ->
      frequencies = group |> Enum.join() |> String.split("", trim: true) |> Enum.frequencies()

      count = frequencies["\n"]

      Map.delete(frequencies, "\n")
      |> Enum.count(fn {_, v} -> v == count end)
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day6Part2.run()
