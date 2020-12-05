defmodule Day5Part2 do
  def run do
    File.stream!("input")
    |> Stream.map(&seat_id/1)
    |> Enum.sort()
    |> find_seat()
    |> IO.puts()
  end

  def find_seat([_ | next_seats] = seats) do
    Stream.zip(seats, next_seats)
    |> Enum.find(fn {seat, next} -> next - seat > 1 end)
    |> elem(0)
    |> Kernel.+(1)
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

  # ALTERNATIVE PARSER ADDED AFTER READING OTHER SUBMISSIONS
  # The boarding pass is actually just a binary number, so we can parse it as such directly.
  # (The *8 above is eqivalent to the 3-bit shift to the left)
  def char_to_bit(c) when c in 'FL', do: <<0::1>>
  def char_to_bit(c) when c in 'BR', do: <<1::1>>

  def seat_id_bitstring(boarding_pass \\ "FBFBBFFRLR") do
    boarding_pass = String.trim(boarding_pass)
    <<id::integer-10>> = for <<char <- boarding_pass>>, into: <<>>, do: char_to_bit(char)
    id
  end
end

Day5Part2.run()
