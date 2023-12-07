#!/usr/bin/env elixir
defmodule Day7 do
  def part1(input) do
    input
    |> Enum.sort_by(&detect_type/1, &rank/2)
    |> Enum.with_index()
    |> Enum.map(fn {{_hand, bid}, rank} -> bid * (rank + 1) end)
    |> Enum.sum()
  end

  def detect_type({hand, _bid}) do
    frequencies =
      hand
      |> Enum.frequencies()
      |> Enum.group_by(fn {_card, freq} -> freq end)
      |> Map.new(fn {freq, cards} -> {freq, length(cards)} end)

    type =
      cond do
        frequencies[5] -> :five_kind
        frequencies[4] -> :four_kind
        frequencies[3] && frequencies[2] -> :full_house
        frequencies[3] -> :three_kind
        frequencies[2] == 2 -> :two_pair
        frequencies[2] -> :one_pair
        true -> :high_card
      end

    {type, hand}
  end

  def rank({same_type, hand1}, {same_type, hand2}), do: tiebreak(hand1, hand2)
  def rank({:high_card, _}, _), do: true
  def rank({:one_pair, _}, {:high_card, _}), do: false
  def rank({:one_pair, _}, _), do: true
  def rank({:two_pair, _}, {b, _}) when b in [:high_card, :one_pair], do: false
  def rank({:two_pair, _}, _), do: true
  def rank({:three_kind, _}, {b, _}) when b in [:high_card, :one_pair, :two_pair], do: false
  def rank({:three_kind, _}, _), do: true
  def rank({:full_house, _}, {b, _}) when b in [:five_kind, :four_kind], do: true
  def rank({:full_house, _}, _), do: false
  def rank({:four_kind, _}, {:five_kind, _}), do: true
  def rank({:four_kind, _}, _), do: false
  def rank({:five_kind, _}, _), do: false

  def tiebreak([first | resta], [first | restb]), do: tiebreak(resta, restb)
  def tiebreak(["1" | _], _), do: true
  def tiebreak(["2" | _], ["1" | _]), do: false
  def tiebreak(["2" | _], _), do: true
  def tiebreak(["3" | _], [b | _]) when b in ["1", "2"], do: false
  def tiebreak(["3" | _], _), do: true
  def tiebreak(["4" | _], [b | _]) when b in ["1", "2", "3"], do: false
  def tiebreak(["4" | _], _), do: true
  def tiebreak(["5" | _], [b | _]) when b in ["1", "2", "3", "4"], do: false
  def tiebreak(["5" | _], _), do: true
  def tiebreak(["6" | _], [b | _]) when b in ["1", "2", "3", "4", "5"], do: false
  def tiebreak(["6" | _], _), do: true
  def tiebreak(["7" | _], [b | _]) when b in ["1", "2", "3", "4", "5", "6"], do: false
  def tiebreak(["7" | _], _), do: true
  def tiebreak(["8" | _], [b | _]) when b in ["A", "K", "Q", "J", "T", "9"], do: true
  def tiebreak(["8" | _], _), do: false
  def tiebreak(["9" | _], [b | _]) when b in ["A", "K", "Q", "J", "T"], do: true
  def tiebreak(["9" | _], _), do: false
  def tiebreak(["T" | _], [b | _]) when b in ["A", "K", "Q", "J"], do: true
  def tiebreak(["T" | _], _), do: false
  def tiebreak(["J" | _], [b | _]) when b in ["A", "K", "Q"], do: true
  def tiebreak(["J" | _], _), do: false
  def tiebreak(["Q" | _], [b | _]) when b in ["A", "K"], do: true
  def tiebreak(["Q" | _], _), do: false
  def tiebreak(["K" | _], ["A" | _]), do: true
  def tiebreak(["K" | _], _), do: false
  def tiebreak(["A" | _], _), do: false

  def part2(_input) do
    :ok
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [hands, bid] = String.split(line)
        {String.graphemes(hands), String.to_integer(bid)}
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
    IO.puts("#{inspect(result)}\n")
  end

  defp format_time(μsec) when μsec < 1_000, do: "#{μsec}μs"
  defp format_time(μsec) when μsec < 1_000_000, do: "#{μsec / 1000}ms"
  defp format_time(μsec), do: "#{μsec / 1_000_000}s"

  defp print_usage do
    IO.puts("Usage: elixir day7.exs input_filename")
  end
end

# Day7.run()
