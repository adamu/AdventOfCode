defmodule Day14Part1 do
  use Bitwise

  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_command/1)
    |> Enum.reduce({nil, %{}}, &execute/2)
    |> sum_memory()
    |> IO.inspect()
  end

  def execute({:mask, mask}, {_mask, mem}), do: {mask, mem}

  def execute({:mem, addr, value}, {mask, mem}) do
    masked_value = apply_mask(value, mask)
    {mask, Map.put(mem, addr, masked_value)}
  end

  def sum_memory({_mask, mem}), do: Map.values(mem) |> Enum.sum()

  def apply_mask(value, {andmask, ormask}), do: (value &&& andmask) ||| ormask

  def parse_command("mask = " <> mask), do: {:mask, decode_mask(mask)}

  def parse_command(mem_command) do
    [addr, value] =
      mem_command
      |> String.split(["mem[", "] = "], trim: true)
      |> Enum.map(&String.to_integer/1)

    {:mem, addr, value}
  end

  def decode_mask(mask) when byte_size(mask) == 36 do
    <<andmask::36>> = for <<bit::binary-1 <- mask>>, into: <<>>, do: andmask_bit(bit)
    <<ormask::36>> = for <<bit::binary-1 <- mask>>, into: <<>>, do: ormask_bit(bit)
    {andmask, ormask}
  end

  def andmask_bit("X"), do: <<1::1>>
  def andmask_bit("1"), do: <<1::1>>
  def andmask_bit("0"), do: <<0::1>>

  def ormask_bit("X"), do: <<0::1>>
  def ormask_bit("1"), do: <<1::1>>
  def ormask_bit("0"), do: <<0::1>>
end

Day14Part1.run()
