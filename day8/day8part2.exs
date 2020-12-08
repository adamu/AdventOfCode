defmodule Day8Part2 do
  def run do
    File.read!("input")
    |> input_to_instrs()
    |> find_corrupted()
    |> IO.puts()
  end

  def input_to_instrs(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/\A(\w{3}) ([+\-]\d+)\z/, &1, capture: :all_but_first))
    |> Enum.with_index()
    |> Map.new(fn {[op, arg], idx} -> {idx, {op, String.to_integer(arg)}} end)
  end

  def find_corrupted(instrs), do: find_corrupted(Map.to_list(instrs), instrs, :loop)

  def find_corrupted(_rest, _instrs, {:terminated, acc}), do: acc

  def find_corrupted([{idx, {op, arg}} | rest], instrs, :loop) do
    result =
      instrs
      |> Map.put(idx, toggle_op(op, arg))
      |> try_boot()

    find_corrupted(rest, instrs, result)
  end

  def toggle_op("acc", arg), do: {"acc", arg}
  def toggle_op("nop", arg), do: {"jmp", arg}
  def toggle_op("jmp", arg), do: {"nop", arg}

  def try_boot(instrs), do: try_boot(instrs, 0, 0, MapSet.new())

  def try_boot(instrs, idx, acc, _seen) when idx == map_size(instrs), do: {:terminated, acc}

  def try_boot(instrs, idx, acc, seen) do
    if MapSet.member?(seen, idx) do
      :loop
    else
      seen = MapSet.put(seen, idx)
      {idx, acc} = execute(instrs[idx], idx, acc)
      try_boot(instrs, idx, acc, seen)
    end
  end

  def execute({"nop", _arg}, idx, acc), do: {idx + 1, acc}
  def execute({"jmp", arg}, idx, acc), do: {idx + arg, acc}
  def execute({"acc", arg}, idx, acc), do: {idx + 1, acc + arg}
end

Day8Part2.run()
