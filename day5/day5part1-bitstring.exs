defmodule Day5Part1 do
  def run do
    File.stream!("input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&seat_id/1)
    |> Enum.max()
    |> IO.puts()
  end

  def char_to_bit(c) when c in 'FL', do: <<0::1>>
  def char_to_bit(c) when c in 'BR', do: <<1::1>>

  def seat_id(boarding_pass) do
    <<id::10>> = for <<char <- boarding_pass>>, into: <<>>, do: char_to_bit(char)
    id
  end
end

Day5Part1.run()
