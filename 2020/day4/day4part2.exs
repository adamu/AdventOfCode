defmodule Day4Part2 do
  @required MapSet.new(["byr", "ecl", "eyr", "hcl", "hgt", "iyr", "pid"])

  def run do
    File.read!("input")
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn passport ->
      passport
      |> String.split([" ", "\n"])
      |> Enum.map(&String.split(&1, ":"))
      |> Map.new(fn [k, v] -> {k, v} end)
      |> Map.delete("cid")
    end)
    |> Enum.filter(&MapSet.subset?(@required, &1 |> Map.keys() |> MapSet.new()))
    |> Enum.count(&valid?/1)
    |> IO.puts()
  end

  def valid?(passport) do
    byr?(passport) && iyr?(passport) && eyr?(passport) && hgt?(passport) && hcl?(passport) &&
      ecl?(passport) && pid?(passport)
  end

  def byr?(%{"byr" => byr}) do
    date = String.to_integer(byr)
    1920 <= date && date <= 2002
  end

  def iyr?(%{"iyr" => iyr}) do
    date = String.to_integer(iyr)
    2010 <= date && date <= 2020
  end

  def eyr?(%{"eyr" => eyr}) do
    date = String.to_integer(eyr)
    2020 <= date && date <= 2030
  end

  def hgt?(%{"hgt" => hgt}) do
    {hgt, unit} =
      case Regex.run(~r/\A(\d+)([^\d]+)\z/, hgt, capture: :all_but_first) do
        [hgt, unit] -> {String.to_integer(hgt), unit}
        nil -> {0, nil}
      end

    case unit do
      "cm" -> 150 <= hgt && hgt <= 193
      "in" -> 59 <= hgt && hgt <= 76
      nil -> false
    end
  end

  def hcl?(%{"hcl" => hcl}) do
    Regex.match?(~r/\A#[0-9a-f]{6}\z/, hcl)
  end

  def ecl?(%{"ecl" => ecl}) do
    ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  end

  def pid?(%{"pid" => pid}) do
    Regex.match?(~r/\A\d{9}\z/, pid)
  end
end

Day4Part2.run()
