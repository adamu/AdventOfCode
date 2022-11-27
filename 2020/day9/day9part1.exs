defmodule Day9Part1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> find_invalid()
    |> IO.puts()
  end

  def find_invalid([_ | next] = numbers) do
    {preamble, [number | _]} = Enum.split(numbers, 25)
    sorted_preamble = Enum.sort(preamble)
    max = number - hd(sorted_preamble)

    if sum_in_preamble?(sorted_preamble, max, number) do
      find_invalid(next)
    else
      number
    end
  end

  def sum_in_preamble?([], _max, _number), do: false
  def sum_in_preamble?([preamble_head | _], max, _number) when preamble_head >= max, do: false

  def sum_in_preamble?([preamble_head | preamble_rest], max, number) do
    if forms_pair?(preamble_head, preamble_rest, max, number) do
      true
    else
      sum_in_preamble?(preamble_rest, max, number)
    end
  end

  def forms_pair?(_x, [y | _], max, _number) when y > max, do: false
  def forms_pair?(_x, [], _max, _number), do: false
  def forms_pair?(x, [y | _], _max, number) when x + y == number, do: true
  def forms_pair?(x, [_y | rest], max, number), do: forms_pair?(x, rest, max, number)
end

Day9Part1.run()
