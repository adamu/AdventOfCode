defmodule Day2 do
  def part1(input) do
    input
    |> Enum.map(fn
      {opponent, "X"} -> {opponent, :rock}
      {opponent, "Y"} -> {opponent, :paper}
      {opponent, "Z"} -> {opponent, :scissors}
    end)
    |> Enum.map(&play/1)
    |> Enum.sum()
  end

  @rock 1
  @paper 2
  @scissors 3
  @lose 0
  @draw 3
  @win 6

  defp play({:rock, :rock}), do: @rock + @draw
  defp play({:paper, :rock}), do: @rock + @lose
  defp play({:scissors, :rock}), do: @rock + @win
  defp play({:rock, :paper}), do: @paper + @win
  defp play({:paper, :paper}), do: @paper + @draw
  defp play({:scissors, :paper}), do: @paper + @lose
  defp play({:rock, :scissors}), do: @scissors + @lose
  defp play({:paper, :scissors}), do: @scissors + @win
  defp play({:scissors, :scissors}), do: @scissors + @draw

  def part2(input) do
    input
    |> Enum.map(fn
      {opponent, "X"} -> {opponent, :lose}
      {opponent, "Y"} -> {opponent, :draw}
      {opponent, "Z"} -> {opponent, :win}
    end)
    |> Enum.map(&play2/1)
    |> Enum.sum()
  end

  defp play2({:rock, :win}), do: @win + @paper
  defp play2({:paper, :win}), do: @win + @scissors
  defp play2({:scissors, :win}), do: @win + @rock
  defp play2({:rock, :draw}), do: @draw + @rock
  defp play2({:paper, :draw}), do: @draw + @paper
  defp play2({:scissors, :draw}), do: @draw + @scissors
  defp play2({:rock, :lose}), do: @lose + @scissors
  defp play2({:paper, :lose}), do: @lose + @rock
  defp play2({:scissors, :lose}), do: @lose + @paper

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split([" ", "\n"], trim: true)
      |> Enum.map(fn
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
        me -> me
      end)
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)
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
    IO.puts("Usage: elixir day2.exs input_filename")
  end
end

Day2.run()
