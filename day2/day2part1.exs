defmodule Day2Part1 do
  def run do
    regex = ~r/\A(\d+)-(\d+) (\w): (\w+)\z/

    File.read!("input")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&Regex.run(regex, &1, capture: :all_but_first))
    |> Enum.map(fn [least, most, char, password] ->
      {String.to_integer(least), String.to_integer(most), char, password}
    end)
    |> Enum.filter(fn {least, most, char, password} ->
      count = Enum.count(String.graphemes(password), &(&1 == char))
      least <= count && count <= most
    end)
    |> Enum.count()
    |> IO.puts()
  end
end

Day2Part1.run()
