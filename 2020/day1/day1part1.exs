defmodule Day1Part1 do
  def run do
    {a, b} =
      File.read!("input")
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> find_2020()

    IO.puts("#{a} x #{b} = #{a * b}")
  end

  def find_2020([current | rest]) do
    target = 2020 - current

    if Enum.member?(rest, target) do
      {current, target}
    else
      find_2020(rest)
    end
  end
end

Day1Part1.run()
