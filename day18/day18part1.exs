defmodule Day18Part1 do
  def run do
    File.stream!("input")
    |> Stream.map(&parse_line/1)
    |> Stream.map(&evaluate/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def parse_line(line) do
    line
    |> String.graphemes()
    |> Stream.reject(fn char -> char in [" ", "\n"] end)
    |> Enum.map(fn
      symbol when symbol in ["*", "+", "(", ")"] -> symbol
      num -> String.to_integer(num)
    end)
  end

  def evaluate(command), do: evaluate(command, nil, 0)
  def evaluate([], nil, acc), do: acc
  def evaluate(["*" | rest], nil, acc), do: evaluate(rest, "*", acc)
  def evaluate(["+" | rest], nil, acc), do: evaluate(rest, "+", acc)
  def evaluate(["(" | rest], op, acc), do: evaluate(rest) |> evaluate(op, acc)
  def evaluate([")" | rest], nil, acc), do: [acc | rest]
  def evaluate([num | rest], "*", acc), do: evaluate(rest, nil, acc * num)
  def evaluate([num | rest], "+", acc), do: evaluate(rest, nil, acc + num)
  def evaluate([num | rest], nil, 0), do: evaluate(rest, nil, num)
end

Day18Part1.run()
