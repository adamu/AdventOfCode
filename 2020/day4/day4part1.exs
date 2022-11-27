defmodule Day4Part1 do
  @required MapSet.new(["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"])

  def run do
    File.read!("input")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn passport ->
      passport
      |> String.split([" ", "\n"])
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.into(MapSet.new(), fn [k, _] -> k end)
    end)
    |> Enum.count(&MapSet.subset?(@required, &1))
    |> IO.puts()
  end
end

Day4Part1.run()
