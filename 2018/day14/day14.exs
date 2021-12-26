defmodule Day14 do
  # Cyclical linked list
  # Use a map, with a ref as the key.
  # Each element contains the value, and next pointer
  # Keep two pointers for the current recipies
  defmodule Recipe do
    defstruct ~w/score next/a
  end

  defmodule State do
    defstruct ~w/recipes first_elf second_elf last target count target_count last_seq desired_sequence/a
  end

  def init(target_count) do
    desired_sequence =
      target_count
      |> Integer.to_string()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    last_seq =
      (for(_i <- 1..(tuple_size(desired_sequence) - 2), do: nil) ++ [3, 7])
      |> List.to_tuple()

    first_elf = System.unique_integer()
    second_elf = System.unique_integer()

    %State{
      first_elf: first_elf,
      second_elf: second_elf,
      last: second_elf,
      target: nil,
      target_count: target_count,
      count: 2,
      desired_sequence: desired_sequence,
      last_seq: last_seq,
      recipes: %{
        first_elf => %Recipe{score: 3, next: second_elf},
        second_elf => %Recipe{score: 7, next: first_elf}
      }
    }
  end

  def combine_recipes(a, b) do
    (a + b)
    |> Integer.to_string()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def append_score(score, %{last: prev_last, recipes: recipes} = state) do
    last_seq =
      state.last_seq
      |> Tuple.delete_at(0)
      |> Tuple.append(score)

    last = System.unique_integer()

    updated_recipes =
      recipes
      |> Map.put(prev_last, %Recipe{recipes[prev_last] | next: last})
      |> Map.put(last, %Recipe{score: score, next: recipes[prev_last].next})

    state = %State{
      state
      | last: last,
        recipes: updated_recipes,
        count: state.count + 1
    }

    state =
      if state.count === state.target_count do
        %State{state | target: last}
      else
        state
      end

    if state.last_seq === state.desired_sequence do
      state
    else
      %State{state | last_seq: last_seq}
    end
  end

  def next_recipe(current, 0, _recipes), do: current

  def next_recipe(current, steps, recipes) do
    next_recipe(recipes[current].next, steps - 1, recipes)
  end

  def next_recipes(%{first_elf: first_elf, second_elf: second_elf, recipes: recipes} = state) do
    %State{
      state
      | first_elf: next_recipe(first_elf, recipes[first_elf].score + 1, recipes),
        second_elf: next_recipe(second_elf, recipes[second_elf].score + 1, recipes)
    }
  end

  # Set the target pointer when the target count is reached
  def set_target(%{count: target, last: last} = state, target), do: %State{state | target: last}
  def set_target(state, _target), do: state

  def compute_recipes(%{count: count, target_count: target} = state) when count >= target + 10,
    do: state

  def compute_recipes(%{first_elf: elf1, second_elf: elf2, recipes: recipes} = state) do
    combine_recipes(recipes[elf1].score, recipes[elf2].score)
    |> Enum.reduce(state, &append_score/2)
    |> next_recipes()
    |> compute_recipes()
  end

  def next_ten_scores(_recipes, _current, scores, 10), do: scores

  def next_ten_scores(recipes, current, scores, count) do
    next = recipes[current].next
    scores = scores <> Integer.to_string(recipes[next].score)
    next_ten_scores(recipes, next, scores, count + 1)
  end

  def part1 do
    state = init(330_121) |> compute_recipes()
    next_ten_scores(state.recipes, state.target, "", 0)
  end

  # Part 2
  # Produce recipes until the last 6 are the puzzle input
  # Then the answer is the count before those 6
  def find_sequence(%{desired_sequence: desired, last_seq: desired, count: count}) do
    count - tuple_size(desired)
  end

  def find_sequence(%{first_elf: elf1, second_elf: elf2, recipes: recipes} = state) do
    if rem(state.count, 100_000) == 0 do
      IO.puts((state.last_seq |> Tuple.to_list() |> Enum.join()) <> " (#{state.count})")
    end

    combine_recipes(recipes[elf1].score, recipes[elf2].score)
    |> Enum.reduce(state, &append_score/2)
    |> next_recipes()
    |> find_sequence()
  end

  # TODO both 1245 and the actual answer are +1. Fix.
  def part2 do
    IO.puts("tests...")
    init(51589) |> find_sequence |> IO.puts()
    init(1245) |> find_sequence |> IO.puts()
    init(92510) |> find_sequence |> IO.puts()
    init(59414) |> find_sequence |> IO.puts()
    IO.puts("answer: (after about 20M items)...")
    init(330_121) |> find_sequence
  end
end
