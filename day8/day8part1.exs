defmodule Day8Part1 do
  def run do
    File.read!("input")
    |> input_to_instrs()
    |> run_until_loop()
    |> IO.puts()
  end

  def input_to_instrs(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/\A(\w{3}) ([+\-]\d+)\z/, &1, capture: :all_but_first))
    |> Enum.with_index()
    |> Map.new(fn {[op, arg], idx} -> {idx, {op, String.to_integer(arg)}} end)
  end

  def run_until_loop(instrs), do: run_until_loop(instrs, 0, 0, MapSet.new())

  def run_until_loop(instrs, idx, acc, seen) do
    if MapSet.member?(seen, idx) do
      acc
    else
      seen = MapSet.put(seen, idx)
      {idx, acc} = execute(instrs[idx], idx, acc)
      run_until_loop(instrs, idx, acc, seen)
    end
  end

  def execute({"nop", _arg}, idx, acc), do: {idx + 1, acc}
  def execute({"jmp", arg}, idx, acc), do: {idx + arg, acc}
  def execute({"acc", arg}, idx, acc), do: {idx + 1, acc + arg}
end

Day8Part1.run()
