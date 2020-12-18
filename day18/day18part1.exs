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
      "*" -> :multiply
      "+" -> :add
      "(" -> :start_group
      ")" -> :end_group
      num -> String.to_integer(num)
    end)
  end

  def evaluate(command), do: evaluate(command, nil, 0)
  def evaluate([], nil, acc), do: acc
  def evaluate([:multiply | rest], nil, acc), do: evaluate(rest, :multiply, acc)
  def evaluate([:add | rest], nil, acc), do: evaluate(rest, :add, acc)

  def evaluate([:start_group | rest], op, acc) do
    {remaining, group_result} = evaluate(rest, nil, 0)
    evaluate([group_result | remaining], op, acc)
  end

  def evaluate([:end_group | rest], _op, acc), do: {rest, acc}
  def evaluate([num | rest], :multiply, acc), do: evaluate(rest, nil, acc * num)
  def evaluate([num | rest], :add, acc), do: evaluate(rest, nil, acc + num)
  def evaluate([num | rest], nil, 0), do: evaluate(rest, nil, num)
end

Day18Part1.run()
