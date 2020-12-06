defmodule Day6Part2 do
  def run do
    File.read!("input")
    |> String.trim()
    |> String.split("\n\n")
    |> Stream.map(fn group ->
      count =
        group
        |> String.to_charlist()
        |> Enum.count(&(&1 == ?\n))
        |> Kernel.+(1)

      group
      |> String.replace("\n", "")
      |> String.split("", trim: true)
      |> Enum.frequencies()
      |> Enum.count(fn {_, v} -> v == count end)
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end

Day6Part2.run()
