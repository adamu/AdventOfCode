defmodule Star do
  defstruct [:pos_x, :pos_y, :vel_x, :vel_y]

  def move_all(stars, secs) do
    Enum.map(stars, &move(&1, secs))
  end

  def move(star, secs) do
    %Star{star | pos_x: star.pos_x + star.vel_x * secs, pos_y: star.pos_y + star.vel_y * secs}
  end
end

defmodule Day10 do
  @input_pattern ~r/=< ?(-?\d+),  ?(-?\d+)>.*=< ?(-?\d+),  ?(-?\d+)>/

  def parse_line(line) do
    [pos_x, pos_y, v_x, v_y] =
      Regex.run(@input_pattern, line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    %Star{pos_x: pos_x, pos_y: pos_y, vel_x: v_x, vel_y: v_y}
  end

  def init do
    File.stream!("input")
    |> Enum.map(&parse_line/1)
  end

  # Start with the first star, then compare all the others to find the extremities
  def bounding_box([%Star{pos_x: x, pos_y: y} | _] = stars) do
    Enum.reduce(stars, {x, y, x, y}, fn star, {min_x, min_y, max_x, max_y} ->
      {
        min(star.pos_x, min_x),
        min(star.pos_y, min_y),
        max(star.pos_x, max_x),
        max(star.pos_y, max_y)
      }
    end)
  end

  def draw(stars) do
    starfield = MapSet.new(stars, fn star -> {star.pos_x, star.pos_y} end)

    {min_x, min_y, max_x, max_y} = bounding_box(stars)

    grid =
      for y <- min_y..max_y, x <- min_x..max_x do
        eol = if x === max_x, do: "\n", else: ""
        char = if MapSet.member?(starfield, {x, y}), do: "#", else: " "
        char <> eol
      end

    Enum.join(grid)
  end

  def aligned?(stars) do
    starfield = MapSet.new(stars, fn star -> {star.pos_x, star.pos_y} end)
    Enum.all?(stars, &aligned?(&1, starfield))
  end

  def aligned?(star, starfield) do
    neighbours = [
      {star.pos_x - 1, star.pos_y - 1},
      {star.pos_x - 1, star.pos_y},
      {star.pos_x - 1, star.pos_y + 1},
      {star.pos_x, star.pos_y - 1},
      {star.pos_x, star.pos_y + 1},
      {star.pos_x + 1, star.pos_y - 1},
      {star.pos_x + 1, star.pos_y},
      {star.pos_x + 1, star.pos_y + 1}
    ]

    Enum.any?(neighbours, &MapSet.member?(starfield, &1))
  end

  def wait_for_alignment(stars, count) do
    if aligned?(stars) do
      {stars, count}
    else
      stars |> Star.move_all(1) |> wait_for_alignment(count + 1)
    end
  end

  def go do
    {stars, count} = init() |> wait_for_alignment(0)
    IO.puts(draw(stars))
    IO.puts("#{count} seconds")
  end
end

Day10.go()
