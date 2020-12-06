defmodule Day5Part1 do
  def run do
    File.stream!("input")
    |> Stream.map(&seat_id/1)
    |> Enum.max()
    |> IO.puts()
  end

  def seat_id(boarding_pass) do
    {row_spec, col_spec} = boarding_pass |> String.trim() |> String.to_charlist() |> Enum.split(7)

    row =
      Enum.reduce(row_spec, {0, 128}, fn
        ?F, {front, 2} -> front
        ?B, {front, 2} -> front + 1
        ?F, {front, count} -> {front, div(count, 2)}
        ?B, {front, count} -> {front + div(count, 2), div(count, 2)}
      end)

    col =
      Enum.reduce(col_spec, {0, 8}, fn
        ?L, {left, 2} -> left
        ?R, {left, 2} -> left + 1
        ?L, {left, count} -> {left, div(count, 2)}
        ?R, {left, count} -> {left + div(count, 2), div(count, 2)}
      end)

    row * 8 + col
  end
end

Day5Part1.run()
