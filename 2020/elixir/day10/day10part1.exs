defmodule Day10Part1 do
  def run do
    input =
      File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    max = Enum.max(input)
    outlet = 0
    built_in = max + 3

    jolts =
      [outlet, built_in | input]
      |> Enum.sort()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)
      |> Enum.frequencies()

    IO.puts(jolts[1] * jolts[3])
  end
end

Day10Part1.run()
