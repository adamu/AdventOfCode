defmodule Part1 do
  def increment_freq(char, freq_map) do
    Map.update(freq_map, char, 1, &(&1 + 1))
  end

  def to_freq_map(str) do
    str
    |> String.to_charlist()
    |> Enum.reduce(%{}, &increment_freq/2)
  end

  def contains_frequency?(freq_map, freq) do
    Map.values(freq_map) |> Enum.member?(freq)
  end

  def count_twos_and_threes(freq_map, {twos, threes}) do
    twos = if contains_frequency?(freq_map, 2), do: twos + 1, else: twos
    threes = if contains_frequency?(freq_map, 3), do: threes + 1, else: threes
    {twos, threes}
  end

  def run do
    {twos, threes} =
      File.stream!("input")
      |> Stream.map(&String.trim/1)
      |> Stream.map(&to_freq_map/1)
      |> Enum.reduce({0, 0}, &count_twos_and_threes/2)

    IO.puts("#{twos} * #{threes} = #{twos * threes}")
  end
end

Part1.run()
