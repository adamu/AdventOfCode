defmodule Coord do
  defstruct [:x, :y]
end

defmodule Claim do
  defstruct id: nil, pos: %Coord{x: 0, y: 0}, len: %Coord{x: 0, y: 0}
  @input_pattern ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/

  def new_from_str(str) do
    [id, pos_x, pos_y, len_x, len_y] =
      Regex.run(@input_pattern, str, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %Claim{id: id, pos: %Coord{x: pos_x, y: pos_y}, len: %Coord{x: len_x, y: len_y}}
  end

  def all_coords(claim) do
    x_coords = claim.pos.x..(claim.pos.x + claim.len.x - 1)
    y_coords = claim.pos.y..(claim.pos.y + claim.len.y - 1)
    for x <- x_coords, y <- y_coords, do: %Coord{x: x, y: y}
  end

  def unshared?(claim, unshared_inches) do
    Enum.all?(all_coords(claim), &MapSet.member?(unshared_inches, &1))
  end
end

defmodule Day3 do
  def count_claim_inches(claim, count) do
    Enum.reduce(Claim.all_coords(claim), count, fn coord, count ->
      Map.update(count, coord, 1, &(&1 + 1))
    end)
  end

  def part1 do
    File.stream!("input")
    |> Stream.map(&Claim.new_from_str/1)
    |> Enum.reduce(%{}, &count_claim_inches/2)
    |> Stream.filter(fn {_coord, count} -> count >= 2 end)
    |> Enum.count()
  end

  def part2 do
    all_claims = File.stream!("input") |> Enum.map(&Claim.new_from_str/1)

    unshared_inches =
      all_claims
      |> Enum.reduce(%{}, &count_claim_inches/2)
      |> Enum.filter(fn {_coord, count} -> count == 1 end)
      |> MapSet.new(fn {coord, _count} -> coord end)

    Enum.find(all_claims, &Claim.unshared?(&1, unshared_inches))
  end
end

IO.puts("Part1 (number of square inches claimed multiple times): #{Day3.part1()}")
IO.puts("Part2 (id of only claim not overlapping with another): #{Day3.part2().id}")
