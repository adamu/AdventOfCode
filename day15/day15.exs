defmodule Day15 do
  @input [18, 8, 0, 5, 4, 1, 20]

  def run do
    [stop] = System.argv()

    start(@input, nil, 1, String.to_integer(stop), %{})
    |> IO.puts()
  end

  def start([], last, round, stop, state), do: play(last, round, stop, state)

  def start([num | rest], _last, round, stop, state) do
    start(rest, num, round + 1, stop, Map.put(state, num, {round, round}))
  end

  def play(num, stop, stop, state) do
    {a, b} = state[num]
    b - a
  end

  def play(num, round, stop, state) do
    {a, b} = state[num]
    say = b - a
    state = Map.update(state, say, {round, round}, fn {_a, b} -> {b, round} end)
    play(say, round + 1, stop, state)
  end
end

Day15.run()
