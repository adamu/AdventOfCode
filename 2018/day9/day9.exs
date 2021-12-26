defmodule Marble do
  defstruct [:cw, :ccw]
end

defmodule Game do
  defstruct [:current, :next, :circle, :players, :active, :scores, :marbles]

  def start(players, marbles) do
    game = %Game{
      current: 0,
      next: 1,
      circle: %{0 => %Marble{ccw: 0, cw: 0}},
      players: players,
      active: 1,
      scores: Map.new(1..players, &{&1, 0}),
      marbles: marbles
    }

    play(game)
  end

  def next_turn(%Game{next: next, marbles: marbles} = game) when next > marbles do
    game.scores |> Map.values() |> Enum.max()
  end

  def next_turn(%Game{players: players, active: active} = game) do
    next = active + 1
    next = if next <= players, do: next, else: 1
    play(%Game{game | active: next})
  end

  def insert(circle, val, ccw, cw) do
    circle
    |> Map.put(val, %Marble{ccw: ccw, cw: cw})
    |> Map.update!(ccw, &%Marble{&1 | cw: val})
    |> Map.update!(cw, &%Marble{&1 | ccw: val})
  end

  def remove(circle, val, ccw, cw) do
    circle
    |> Map.delete(val)
    |> Map.update!(ccw, &%Marble{&1 | cw: cw})
    |> Map.update!(cw, &%Marble{&1 | ccw: ccw})
  end

  def find_remove(cw, circle, 1) do
    remove = circle[cw].ccw
    ccw = circle[remove].ccw
    {remove, ccw, cw}
  end

  def find_remove(current, circle, dec) do
    find_remove(circle[current].ccw, circle, dec - 1)
  end

  def play(%Game{current: current, next: val, circle: circle} = game) when rem(val, 23) == 0 do
    # Find and remove the item 7 items over
    {remove, ccw, cw} = find_remove(current, circle, 7)
    circle = remove(circle, remove, ccw, cw)

    # Update the player's score
    scores = Map.update!(game.scores, game.active, &(&1 + val + remove))

    game = %Game{game | current: cw, next: val + 1, circle: circle, scores: scores}
    next_turn(game)
  end

  def play(%Game{current: current, next: val, circle: circle} = game) do
    one = circle[current].cw
    two = circle[one].cw
    game = %Game{game | current: val, next: val + 1, circle: insert(circle, val, one, two)}
    next_turn(game)
  end
end

defmodule Day9 do
  def part1 do
    input = File.read!("input")
    pattern = ~r/(\d+) players; last marble is worth (\d+) points/

    [players, marbles] =
      Regex.run(pattern, input, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    Game.start(players, marbles)
  end

  # Probably supposed to make this more efficient, but it still runs in 30 seconds...
  def part2 do
    input = File.read!("input")
    pattern = ~r/(\d+) players; last marble is worth (\d+) points/

    [players, marbles] =
      Regex.run(pattern, input, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    Game.start(players, marbles * 100)
  end
end

IO.puts(Day9.part1())
IO.puts(Day9.part2())
