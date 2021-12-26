defmodule Day13 do
  defmodule Cart do
    defstruct dir: nil, turn: :left
  end

  defmodule Parser do
    # track pieces
    # | - / \ +
    # Carts
    # ^ v < >
    # Inital cart = straight track underneath
    # Sample input:
    # /->-\        
    # |   |  /----\
    # | /-+--+-\  |
    # | | |  | v  |
    # \-+-/  \-+--/
    #  \------/   
    def parse_file(filename) do
      rows =
        File.read!(filename)
        |> String.split("\n")
        |> Enum.map(&String.to_charlist/1)

      {_, track, carts} =
        Enum.reduce(rows, {0, %{}, %{}}, fn row, {row_idx, track, carts} ->
          {_, _, track, carts} = Enum.reduce(row, {row_idx, 0, track, carts}, &parse_char/2)
          {row_idx + 1, track, carts}
        end)

      {track, carts}
    end

    defp parse_char(?\s, {row_idx, col_idx, track, carts}) do
      {row_idx, col_idx + 1, track, carts}
    end

    defp parse_char(cart, args) when cart in '^v<>', do: parse_cart(cart, args)
    defp parse_char(track, args) when track in '|-/\\+', do: parse_track(track, args)

    defp parse_cart(?^, {row_idx, col_idx, track, carts}) do
      carts = Map.put(carts, {row_idx, col_idx}, %Cart{dir: :up})
      parse_track(?|, {row_idx, col_idx, track, carts})
    end

    defp parse_cart(?v, {row_idx, col_idx, track, carts}) do
      carts = Map.put(carts, {row_idx, col_idx}, %Cart{dir: :down})
      parse_track(?|, {row_idx, col_idx, track, carts})
    end

    defp parse_cart(?<, {row_idx, col_idx, track, carts}) do
      carts = Map.put(carts, {row_idx, col_idx}, %Cart{dir: :left})
      parse_track(?-, {row_idx, col_idx, track, carts})
    end

    defp parse_cart(?>, {row_idx, col_idx, track, carts}) do
      carts = Map.put(carts, {row_idx, col_idx}, %Cart{dir: :right})
      parse_track(?-, {row_idx, col_idx, track, carts})
    end

    defp parse_track(char, {row_idx, col_idx, track, carts}) do
      track = Map.put(track, {row_idx, col_idx}, <<char::utf8>>)
      {row_idx, col_idx + 1, track, carts}
    end
  end

  # Plan:
  # Build a giant coordinate map containing what piece of track is at a coordinate
  # (spaces with no track can be skipped)
  # Build a separate map of carts
  # Carts should contain their location, dir, and next turn
  # -> Sort the map each tick to determine cart order
  # For a tick, go through each cart and update it's location (key), dir, and next turn
  # - if there's a collision, we can stop early and return the location

  def sort(carts) do
    Enum.sort(carts, fn {{row1, col1}, _}, {{row2, col2}, _} ->
      cond do
        row1 < row2 -> true
        row1 == row2 -> col1 <= col2
        row1 > row2 -> false
      end
    end)
  end

  def next_pos(row, col, %Cart{dir: :up}), do: {row - 1, col}
  def next_pos(row, col, %Cart{dir: :down}), do: {row + 1, col}
  def next_pos(row, col, %Cart{dir: :left}), do: {row, col - 1}
  def next_pos(row, col, %Cart{dir: :right}), do: {row, col + 1}

  def turn(cart, track) when track in ["-", "|"], do: cart
  def turn(%Cart{dir: :left} = cart, "/"), do: %Cart{cart | dir: :down}
  def turn(%Cart{dir: :right} = cart, "/"), do: %Cart{cart | dir: :up}
  def turn(%Cart{dir: :up} = cart, "/"), do: %Cart{cart | dir: :right}
  def turn(%Cart{dir: :down} = cart, "/"), do: %Cart{cart | dir: :left}
  def turn(%Cart{dir: :left} = cart, "\\"), do: %Cart{cart | dir: :up}
  def turn(%Cart{dir: :right} = cart, "\\"), do: %Cart{cart | dir: :down}
  def turn(%Cart{dir: :up} = cart, "\\"), do: %Cart{cart | dir: :left}
  def turn(%Cart{dir: :down} = cart, "\\"), do: %Cart{cart | dir: :right}
  def turn(%Cart{dir: :left, turn: :left}, "+"), do: %Cart{dir: :down, turn: :straight}
  def turn(%Cart{dir: :left, turn: :straight}, "+"), do: %Cart{dir: :left, turn: :right}
  def turn(%Cart{dir: :left, turn: :right}, "+"), do: %Cart{dir: :up, turn: :left}
  def turn(%Cart{dir: :right, turn: :left}, "+"), do: %Cart{dir: :up, turn: :straight}
  def turn(%Cart{dir: :right, turn: :straight}, "+"), do: %Cart{dir: :right, turn: :right}
  def turn(%Cart{dir: :right, turn: :right}, "+"), do: %Cart{dir: :down, turn: :left}
  def turn(%Cart{dir: :up, turn: :left}, "+"), do: %Cart{dir: :left, turn: :straight}
  def turn(%Cart{dir: :up, turn: :straight}, "+"), do: %Cart{dir: :up, turn: :right}
  def turn(%Cart{dir: :up, turn: :right}, "+"), do: %Cart{dir: :right, turn: :left}
  def turn(%Cart{dir: :down, turn: :left}, "+"), do: %Cart{dir: :right, turn: :straight}
  def turn(%Cart{dir: :down, turn: :straight}, "+"), do: %Cart{dir: :down, turn: :right}
  def turn(%Cart{dir: :down, turn: :right}, "+"), do: %Cart{dir: :left, turn: :left}

  def crashed?(pos, unmoved_carts, moved_carts) do
    Map.get(unmoved_carts, pos) || Map.get(moved_carts, pos)
  end

  def tick([], _unmoved_carts, moved_carts, _track), do: {:tock, moved_carts}

  def tick([{{row, col}, cart} | sorted_carts], unmoved_carts, moved_carts, track) do
    # This cart is no longer unmoved (so it can't crash into itself)
    unmoved_carts = Map.delete(unmoved_carts, {row, col})

    next_pos = next_pos(row, col, cart)

    if crashed?(next_pos, unmoved_carts, moved_carts) do
      {:boom, next_pos}
    else
      next_track = Map.fetch!(track, next_pos)
      moved_cart = turn(cart, next_track)
      tick(sorted_carts, unmoved_carts, Map.put(moved_carts, next_pos, moved_cart), track)
    end
  end

  def find_collision(track, carts) do
    case tick(sort(carts), carts, %{}, track) do
      {:tock, carts} -> find_collision(track, carts)
      {:boom, {row, col}} -> "#{col},#{row}"
    end
  end

  def part1 do
    {track, carts} = Parser.parse_file("input")
    find_collision(track, carts)
  end

  # Part 2.
  # Instead of stopping on a crash, we should instead remove the two carts that crashed.
  # Terminating condition is when there is only one cart left.

  def tick2([], _unmoved_carts, moved_carts, _track), do: moved_carts

  def tick2([{{row, col}, cart} | sorted_carts], unmoved_carts, moved_carts, track) do
    unmoved_carts = Map.delete(unmoved_carts, {row, col})
    next_pos = next_pos(row, col, cart)

    if crashed?(next_pos, unmoved_carts, moved_carts) do
      unmoved_carts = Map.delete(unmoved_carts, next_pos)
      moved_carts = Map.delete(moved_carts, next_pos)
      # Could have deleted an unmoved, so need to re-sort the remaining carts to process
      tick2(sort(unmoved_carts), unmoved_carts, moved_carts, track)
    else
      next_track = Map.fetch!(track, next_pos)
      moved_cart = turn(cart, next_track)
      tick2(sorted_carts, unmoved_carts, Map.put(moved_carts, next_pos, moved_cart), track)
    end
  end

  def find_last_cart(track, carts), do: find_last_cart(track, carts, sort(carts))
  def find_last_cart(_track, _carts, [{{row, col}, _cart}]), do: "#{col},#{row}"

  def find_last_cart(track, carts, sorted_carts) do
    find_last_cart(track, tick2(sorted_carts, carts, %{}, track))
  end

  def part2 do
    {track, carts} = Parser.parse_file("input")
    find_last_cart(track, carts)
  end
end
