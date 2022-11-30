defmodule Day16 do
  def part1(input) do
    {_type, _rest, _count, version_sum} = decode_packet(input, 0, 0)
    version_sum
  end

  @literal_type 4
  @literal_part 1
  @literal_end 0
  @total_length_type 0
  @sub_packets_length_type 1

  defp decode_packet(<<version::3, @literal_type::3, rest::bits>>, count, version_sum) do
    decode_literal(rest, <<>>, count + 6, version_sum + version)
  end

  defp decode_packet(<<version::3, operator_type::3, rest::bits>>, count, version_sum) do
    {sub_packets, rest, count, version_sum} =
      case rest do
        <<@total_length_type::1, length::15, rest::bits>> ->
          decode_sub_packets_by(
            :length,
            length,
            [],
            rest,
            count + 3 + 3 + 1 + 15,
            version_sum + version
          )

        <<@sub_packets_length_type::1, num_sub_packets::11, rest::bits>> ->
          decode_sub_packets_by(
            :quantity,
            num_sub_packets,
            [],
            rest,
            count + 3 + 3 + 1 + 11,
            version_sum + version
          )
      end

    {{:operator, operator_type, sub_packets}, rest, count, version_sum}
  end

  defp decode_literal(<<@literal_part::1, group::bits-4, rest::bits>>, acc, count, version_sum) do
    decode_literal(rest, <<acc::bits, group::bits>>, count + 5, version_sum)
  end

  defp decode_literal(<<@literal_end::1, group::bits-4, rest::bits>>, acc, count, version_sum) do
    literal_binary = <<acc::bits, group::bits>>
    <<literal::size(bit_size(literal_binary))>> = literal_binary
    {{:literal, literal}, rest, count + 5, version_sum}
  end

  defp decode_sub_packets_by(_method, 0, decoded_packets, bits, count, version_sum) do
    {Enum.reverse(decoded_packets), bits, count, version_sum}
  end

  defp decode_sub_packets_by(method, remaining, decoded_packets, bits, count, version_sum) do
    {decoded_packet, rest, packet_size, version_sum} = decode_packet(bits, 0, version_sum)

    remaining =
      case method do
        :length -> remaining - packet_size
        :quantity -> remaining - 1
      end

    decode_sub_packets_by(
      method,
      remaining,
      [decoded_packet | decoded_packets],
      rest,
      count + packet_size,
      version_sum
    )
  end

  def part2(input) do
    {packet, _rest, _count, _version_sum} = decode_packet(input, 0, 0)
    evaluate(packet)
  end

  defp evaluate({:literal, literal}), do: literal

  defp evaluate({:operator, op, args}) do
    args
    |> Enum.map(&evaluate/1)
    |> calculate(op)
  end

  defp calculate(args, 0), do: Enum.sum(args)
  defp calculate(args, 1), do: Enum.reduce(args, &Kernel.*/2)
  defp calculate(args, 2), do: Enum.min(args)
  defp calculate(args, 3), do: Enum.max(args)
  defp calculate([a, b], 5), do: if(a > b, do: 1, else: 0)
  defp calculate([a, b], 6), do: if(a < b, do: 1, else: 0)
  defp calculate([a, b], 7), do: if(a == b, do: 1, else: 0)

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> Base.decode16!()
    else
      _ -> :error
    end
  end

  #######################
  # HERE BE BOILERPLATE #
  #######################

  def(run) do
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
    IO.puts("Usage: elixir day16.exs input_filename")
  end
end

Day16.run()
