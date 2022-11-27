defmodule Day2Part2 do
  def run do
    regex = ~r/\A(\d+)-(\d+) (\w): (\w+)\z/

    File.read!("input")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Regex.run(regex, &1, capture: :all_but_first))
    |> Enum.map(fn [first, second, char, password] ->
      {
        String.to_integer(first) - 1,
        String.to_integer(second) - 1,
        char,
        String.graphemes(password)
      }
    end)
    |> Enum.filter(fn {first, second, char, password} ->
      first = Enum.at(password, first) == char
      second = Enum.at(password, second) == char
      (first && !second) || (!first && second)
    end)
    |> Enum.count()
    |> IO.puts()
  end
end

Day2Part2.run()
