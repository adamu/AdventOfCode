defmodule Day6Part1 do
  def run do
    File.read!("input")
    |> String.trim()
    |> String.split("\n\n")
    |> Stream.map(fn group ->
      group
      |> String.replace("\n", "")
      |> String.split("", trim: true)
      |> Enum.frequencies()
      |> Enum.count()
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day6Part1.run()
