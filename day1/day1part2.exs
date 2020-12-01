defmodule Day1Part2 do
  def run do
    {a, b, c} =
      File.read!("input")
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)
      |> find_2020()

    IO.puts("#{a} x #{b} x #{c} = #{a * b * c}")
  end

  def find_2020([current | rest]) do
    pair =
      for i <- rest, j <- rest do
        if current + i + j == 2020, do: {i, j}, else: nil
      end
      |> Enum.find(&match?({_, _}, &1))

    case pair do
      {a, b} -> {a, b, current}
      nil -> find_2020(rest)
    end
  end
end

Day1Part2.run()
