list =
  File.read!("input")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

[{a, b} | _] = for i <- list, j <- list, i + j == 2020, do: {i, j}
IO.puts("Part1: #{a} x #{b} = #{a * b}")

[{a, b, c} | _] = for i <- list, j <- list, k <- list, i + j + k == 2020, do: {i, j, k}
IO.puts("Part2: #{a} x #{b} x #{c} = #{a * b * c}")
