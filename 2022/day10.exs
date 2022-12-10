defmodule Day10 do
  defmodule Instr do
    defstruct cmd: nil, cycles: 0, amt: nil
  end

  def part1(input) do
    process(input, _cycle = 1, _x = 1, _sample_at = 20, _sig = 0)
  end

  defp process([], _cycle, _x, _sample_at, sig), do: sig

  defp process(instrs, cycle, x, sample_at, sig) when cycle == sample_at do
    process(instrs, cycle, x, sample_at + 40, sig + cycle * x)
  end

  defp process([%Instr{cycles: 0} | rest], cycle, x, sample_at, sig) do
    process(rest, cycle + 1, x, sample_at, sig)
  end

  defp process([instr = %Instr{cycles: 1, cmd: :noop} | rest], cycle, x, sample_at, sig) do
    process([%Instr{instr | cycles: 0} | rest], cycle, x, sample_at, sig)
  end

  defp process([instr = %Instr{cycles: 1, cmd: :addx, amt: amt} | rest], cycle, x, sample_at, sig) do
    process([%Instr{instr | cycles: 0} | rest], cycle, x + amt, sample_at, sig)
  end

  defp process([instr = %Instr{cycles: cycles} | rest], cycle, x, sample_at, sig) do
    process([%Instr{instr | cycles: cycles - 1} | rest], cycle + 1, x, sample_at, sig)
  end

  def part2(input) do
    input
    |> scan(_x = 1, _pixel = 0, _pixels = [[]])
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp scan([], _x, _pixel, pixels), do: pixels

  defp scan(instrs, x, _pixel = 40, pixels) do
    scan(instrs, x, _pixel = 0, [[] | pixels])
  end

  defp scan([%Instr{cmd: :noop} | rest], x, pixel, [row | pixels]) do
    scan(rest, x, pixel + 1, [draw_pixel(pixel, x, row) | pixels])
  end

  defp scan([%Instr{cycles: 1, cmd: :addx, amt: amt} | rest], x, pixel, [row | pixels]) do
    scan(rest, x + amt, pixel + 1, [draw_pixel(pixel, x, row) | pixels])
  end

  defp scan([instr = %Instr{cycles: cycles} | rest], x, pixel, [row | pixels]) do
    scan([%Instr{instr | cycles: cycles - 1} | rest], x, pixel + 1, [
      draw_pixel(pixel, x, row) | pixels
    ])
  end

  defp draw_pixel(pixel, x, row) when pixel in (x - 1)..(x + 1), do: ["#" | row]
  defp draw_pixel(_pixel, _x, row), do: [" " | row]

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn
        "noop" -> %Instr{cmd: :noop, cycles: 1}
        "addx " <> x -> %Instr{cmd: :addx, cycles: 2, amt: String.to_integer(x)}
      end)
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
    IO.puts("Usage: elixir day10.exs input_filename")
  end
end

Day10.run()
