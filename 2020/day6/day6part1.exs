defmodule Day6Part1 do
  def run do
    File.stream!("input")
    |> Stream.chunk_by(&(&1 == "\n"))
    |> Stream.map(fn group ->
      group
      |> Enum.join()
      |> String.to_charlist()
      |> Enum.frequencies()
      |> Map.delete(?\n)
      |> Enum.count()
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day6Part1.run()
