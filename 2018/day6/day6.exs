defmodule Area do
  defstruct [:min_x, :min_y, :max_x, :max_y]

  def all_coords(area) do
    for x <- area.min_x..area.max_x, y <- area.min_y..area.max_y, do: {x, y}
  end

  def edge_coords(area) do
    top_and_bottom = for x <- area.min_x..area.max_x, y <- [area.min_y, area.max_y], do: {x, y}
    sides = for x <- [area.min_x, area.max_x], y <- (area.min_y + 1)..(area.max_y - 1), do: {x, y}
    top_and_bottom ++ sides
  end
end

defmodule Day6 do
  def parse_danger_pt_list do
    File.stream!("input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn line -> String.split(line, ", ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [x, y] -> {x, y} end)
  end

  def bounding_box(coords) do
    {max_x, max_y} =
      Enum.reduce(coords, {0, 0}, fn {x, y}, {max_x, max_y} ->
        {max(x, max_x), max(y, max_y)}
      end)

    {min_x, min_y} =
      Enum.reduce(coords, {max_x, max_y}, fn {x, y}, {min_x, min_y} ->
        {min(x, min_x), min(y, min_y)}
      end)

    %Area{min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}
  end

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)

  # %{ grid_coordinate => {distance, dangerous_point} }
  def proximity_grid_for(danger_pt, field) do
    Area.all_coords(field)
    |> Enum.map(fn coord -> {coord, {manhattan_distance(coord, danger_pt), [danger_pt]}} end)
    |> Map.new()
  end

  def proximity_grid(danger_pts, field) do
    empty_grid = Enum.map(danger_pts, fn danger_pt -> {danger_pt, {nil, []}} end) |> Map.new()

    Enum.reduce(danger_pts, empty_grid, fn danger_pt, merged_grid ->
      Map.merge(proximity_grid_for(danger_pt, field), merged_grid, fn
        _grid_coord, {dist, [danger_pt]}, {_dist, []} ->
          {dist, [danger_pt]}

        _grid_coord, {dist1, [danger_pt]}, {dist2, _danger_pts} when dist1 < dist2 ->
          {dist1, [danger_pt]}

        _grid_coord, {dist1, _danger_pt}, {dist2, danger_pts} when dist2 < dist1 ->
          {dist2, danger_pts}

        _grid_coord, {dist1, [danger_pt]}, {dist2, danger_pts} when dist1 === dist2 ->
          {dist1, [danger_pt | danger_pts]}
      end)
    end)
  end

  def find_infinite_danger_pts(proximity_grid, field) do
    Enum.reduce(Area.edge_coords(field), MapSet.new(), fn coord, infinite_pts ->
      with {_dist, [danger_pt]} <- proximity_grid[coord] do
        MapSet.put(infinite_pts, danger_pt)
      else
        _ -> infinite_pts
      end
    end)
  end

  def remove_shared_and_infinite(proximity_grid, infinite_pts) do
    proximity_grid
    |> Enum.reject(fn {_, {_dist, danger_pts}} -> length(danger_pts) > 1 end)
    |> Enum.reject(fn {_, {_dist, [danger_pt]}} -> MapSet.member?(infinite_pts, danger_pt) end)
    |> Map.new()
  end

  def to_areas(proximity_grid) do
    Enum.reduce(proximity_grid, %{}, fn {_coord, {_dist, [danger_pt]}}, areas ->
      Map.update(areas, danger_pt, 1, &(&1 + 1))
    end)
  end

  def part1 do
    danger_pts = parse_danger_pt_list()
    field = bounding_box(danger_pts)
    proximity_grid = proximity_grid(danger_pts, field)
    infinite_pts = find_infinite_danger_pts(proximity_grid, field)

    remove_shared_and_infinite(proximity_grid, infinite_pts)
    |> to_areas()
    |> Map.values()
    |> Enum.max()
  end

  def part2 do
    danger_pts = parse_danger_pt_list()

    danger_pts
    |> bounding_box()
    |> Area.all_coords()
    |> Enum.map(fn coord ->
      Enum.reduce(danger_pts, 0, fn danger_pt, dist ->
        dist + manhattan_distance(coord, danger_pt)
      end)
    end)
    |> Enum.filter(&(&1 < 10_000))
    |> length()
  end
end

IO.puts(Day6.part1())
IO.puts(Day6.part2())
