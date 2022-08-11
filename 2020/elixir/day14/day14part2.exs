defmodule Day14Part2 do
  use Bitwise

  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&Parser.parse_command/1)
    |> Enum.reduce({nil, %{}}, &execute/2)
    |> sum_memory()
    |> IO.inspect()
  end

  def execute({:mask, decoded_mask}, {_decoded_mask, mem}), do: {decoded_mask, mem}

  def execute({:mem, addr, value}, {decoded_mask, mem}) do
    mem =
      apply_mask(addr, decoded_mask)
      |> Enum.reduce(mem, fn addr, mem -> Map.put(mem, addr, value) end)

    {decoded_mask, mem}
  end

  def apply_mask(addr, {mask, replacement_indices}) do
    masked_address = addr ||| mask

    replacement_bits = permute_floating_bits(replacement_indices)
    Enum.map(replacement_bits, &insert_floating_bits(masked_address, &1))
  end

  def insert_floating_bits(value, floating_bits) do
    Enum.reduce(floating_bits, value, fn {idx, bit}, value ->
      replace_bit(value, idx, bit)
    end)
  end

  def replace_bit(number, idx, bit) do
    left = idx
    right = 35 - idx
    <<prefix::size(left), _::1, suffix::size(right)>> = <<number::36>>
    <<number::36>> = <<prefix::size(left), bit::1, suffix::size(right)>>
    number
  end

  # Since it's binary day, let's implement permutations in binary too
  def permute_floating_bits(indices) do
    len = length(indices)
    size = :math.pow(2, len) |> trunc

    for permutation <- 0..(size - 1) do
      bits = for <<(bit::1 <- <<permutation::size(len)>>)>>, do: bit
      Enum.zip(indices, bits)
    end
  end

  def sum_memory({_mask, mem}), do: Map.values(mem) |> Enum.sum()
end

defmodule Parser do
  def parse_command("mask = " <> mask), do: {:mask, decode_mask(mask)}

  def parse_command(mem_command) do
    [addr, value] =
      mem_command
      |> String.split(["mem[", "] = "], trim: true)
      |> Enum.map(&String.to_integer/1)

    {:mem, addr, value}
  end

  def decode_mask(mask) when byte_size(mask) == 36 do
    <<intmask::36>> = for <<bit::binary-1 <- mask>>, into: <<>>, do: mask_bit(bit)
    {intmask, replacement_indices(mask)}
  end

  def mask_bit("X"), do: <<0::1>>
  def mask_bit("1"), do: <<1::1>>
  def mask_bit("0"), do: <<0::1>>

  # 0-indexed from the MOST significant bit
  def replacement_indices(mask) do
    mask
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.filter(&match?({"X", _}, &1))
    |> Enum.map(&elem(&1, 1))
  end
end

Day14Part2.run()
