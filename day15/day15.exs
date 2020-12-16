defmodule Day15 do
  @input [18, 8, 0, 5, 4, 1, 20]

  def run do
    [stop] = System.argv()

    start(@input, nil, 1, String.to_integer(stop), %{})
    |> IO.puts()
  end

  def start([], prev_num, round, stop, state), do: play(prev_num, round, stop, state)

  def start([num | rest], _prev_num, round, stop, state) do
    start(rest, num, round + 1, stop, Map.put(state, num, {round, round}))
  end

  def play(prev_num, stop, stop, state), do: next_num(prev_num, state)

  def play(prev_num, round, stop, state) do
    num = next_num(prev_num, state)
    state = Map.update(state, num, {round, round}, fn {_a, b} -> {b, round} end)
    play(num, round + 1, stop, state)
  end

  def next_num(prev_num, state) do
    {a, b} = state[prev_num]
    b - a
  end
end

Day15.run()
