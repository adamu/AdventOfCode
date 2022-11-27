defmodule Day6Part2 do
  def run do
    File.stream!("input")
    |> Stream.chunk_by(&(&1 == "\n"))
    |> Stream.map(fn group ->
      {count, frequencies} =
        group
        |> Enum.join()
        |> String.to_charlist()
        |> Enum.frequencies()
        |> Map.pop(?\n)

      Enum.count(frequencies, fn {_, v} -> v == count end)
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day6Part2.run()
