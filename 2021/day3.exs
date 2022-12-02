defmodule Day3 do
  def part1(input) do
    gamma_rating = find_rating(input, 0, :most, <<>>)
    epsillon_rating = find_rating(input, 0, :least, <<>>)
    gamma_rating * epsillon_rating
  end

  defp find_rating([value | _], _, _, bits) when bit_size(value) == bit_size(bits) do
    <<rating::size(bit_size(bits))>> = bits
    rating
  end

  defp find_rating(values, bits_seen, mode, acc) do
    bit = find_common(values, bits_seen, mode)
    find_rating(values, bits_seen + 1, mode, <<acc::bits-size(bits_seen), bit::1>>)
  end

  def part2(input) do
    oxygen_generator_rating = find_rating2(input, 0, :most)
    co2_scrubber_rating = find_rating2(input, 0, :least)
    oxygen_generator_rating * co2_scrubber_rating
  end

  defp find_rating2([bits], _bits_seen, _mode) do
    <<value::size(bit_size(bits))>> = bits
    value
  end

  defp find_rating2(values, bits_seen, mode) do
    bit = find_common(values, bits_seen, mode)

    values
    |> filter_by_bit(bits_seen, bit)
    |> find_rating2(bits_seen + 1, mode)
  end

  defp find_common(values, bits_seen, mode) do
    {zeros, ones} =
      values
      |> Enum.map(fn <<_::size(bits_seen), bit::1, _rest::bits>> -> bit end)
      |> Enum.reduce({_zeros = 0, _ones = 0}, fn
        0, {zeros, ones} -> {zeros + 1, ones}
        1, {zeros, ones} -> {zeros, ones + 1}
      end)

    case mode do
      :most -> if zeros <= ones, do: 1, else: 0
      :least -> if zeros <= ones, do: 0, else: 1
    end
  end

  defp filter_by_bit(values, num_prev_bits, bit) do
    Enum.filter(values, &match?(<<_::size(num_prev_bits), ^bit::1, _rest::bits>>, &1))
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      strings = String.split(input, "\n", trim: true)
      length = byte_size(hd(strings))
      Enum.map(strings, &<<String.to_integer(&1, 2)::size(length)>>)
    else
      _ -> :error
    end
  end

  #######################
  # HERE BE BOILERPLATE #
  #######################

  def run do
    case input() do
      :error -> print_usage()
      input -> run_parts_with_timer(input)
    end
  end

  defp run_parts_with_timer(input) do
    run_with_timer(1, fn -> part1(input) end)
    run_with_timer(2, fn -> part2(input) end)
  end

  defp run_with_timer(part, fun) do
    {time, result} = :timer.tc(fun)
    IO.puts("Part #{part} (completed in #{format_time(time)}):\n")
    IO.puts("#{result}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir dayREPLACE_ME.exs input_filename")
  end
end

Day3.run()
