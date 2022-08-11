defmodule Day5Part2 do
  def run do
    File.stream!("input")
    |> Stream.map(&String.trim/1)
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

  def char_to_bit(c) when c in 'FL', do: <<0::1>>
  def char_to_bit(c) when c in 'BR', do: <<1::1>>

  def seat_id(boarding_pass) do
    <<id::10>> = for <<char <- boarding_pass>>, into: <<>>, do: char_to_bit(char)
    id
  end
end

Day5Part2.run()
