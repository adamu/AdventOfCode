defmodule Day25Part1 do
  def run do
    [card_key, door_key] =
      File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    door_loop_size = find_loop_size(1, door_key, 0)

    transform(1, card_key, door_loop_size)
    |> IO.puts()
  end

  def find_loop_size(public_key, public_key, size), do: size

  def find_loop_size(value, key, size) do
    operation(value, 7) |> find_loop_size(key, size + 1)
  end

  def transform(encryption_key, _subject_number, 0), do: encryption_key

  def transform(value, subject_number, size) do
    operation(value, subject_number) |> transform(subject_number, size - 1)
  end

  def operation(value, subject_number), do: rem(value * subject_number, 2020_12_27)
end

Day25Part1.run()
