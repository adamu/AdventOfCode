defmodule Day7 do
  def input_to_graph do
    input_pattern = ~r/Step (\w) must be finished before step (\w) can begin./

    File.stream!("input")
    |> Enum.map(&Regex.run(input_pattern, &1, capture: :all_but_first))
    |> Enum.reduce(%{}, fn [from, to], routes ->
      Map.update(routes, from, [to], fn tos -> [to | tos] end)
    end)
  end

  def count_predecessors(graph) do
    Enum.reduce(graph, %{}, fn {step, _children}, counts ->
      counts = Map.put_new(counts, step, 0)
      count_predecessors(counts, counts[step], graph[step], graph)
    end)
  end

  def count_predecessors(counts, _, nil, _), do: counts

  def count_predecessors(counts, level, children, graph) do
    child_lvl = level + 1

    Enum.reduce(children, counts, fn child, counts ->
      counts = Map.update(counts, child, child_lvl, fn existing -> max(existing, child_lvl) end)
      count_predecessors(counts, counts[child], graph[child], graph)
    end)
  end

  def resolve_steps(graph, steps) when map_size(graph) === 1 do
    [{penultimate, ultimates}] = Map.to_list(graph)
    Enum.reverse(steps) ++ [penultimate | Enum.sort(ultimates)]
  end

  def resolve_steps(graph, steps) do
    before_counts = count_predecessors(graph)

    [next | _] =
      Enum.filter(before_counts, fn {_, count} -> count === 0 end)
      |> Enum.map(fn {step, _count} -> step end)
      |> Enum.sort()

    resolve_steps(Map.delete(graph, next), [next | steps])
  end

  def time_for(step), do: hd(String.to_charlist(step)) - 5

  def get_work({graph, counts, in_progress}) do
    case Enum.filter(counts, fn {_, count} -> count === 0 end)
         |> Enum.map(fn {step, _count} -> step end)
         |> Enum.sort() do
      [] ->
        {nil, {graph, counts, in_progress}}

      [step | _] ->
        {{step, time_for(step)}, {graph, Map.delete(counts, step), [step | in_progress]}}
    end
  end

  def get_work_done(completed_step, {graph, _counts, in_progress}) do
    graph = Map.delete(graph, completed_step)
    counts = count_predecessors(graph) |> Map.drop(in_progress)
    get_work({graph, counts, in_progress})
  end

  def all_prerequisites_allocated?(graph, in_progress) do
    map_size(Map.drop(graph, in_progress)) === 0
  end

  def tick(workers, graph, counts, in_progress, seconds) do
    {workers, {graph, counts, _}} =
      Enum.map_reduce(workers, {graph, counts, in_progress}, fn
        nil, acc -> get_work(acc)
        {step, 0}, acc -> get_work_done(step, acc)
        {step, remaining}, acc -> {{step, remaining - 1}, acc}
      end)

    {workers, graph, counts, seconds + 1}
  end

  def finish_up(workers, counts, seconds) do
    remaining_workers =
      workers
      |> Enum.filter(fn worker -> worker != nil end)
      |> Enum.map(fn {_, time} -> time end)
      |> Enum.max()

    # This assumes the number of remaining jobs will not be greater than the remaining
    # workers. That's probably a bad assumption so if the answer is wrong I'll
    # come back and fix this.
    if map_size(counts) > length(workers) do
      raise("Number of final jobs greater than remaining workers")
    end

    remaining_queued = (counts |> Enum.map(fn {step, _} -> time_for(step) end) |> Enum.max()) + 1

    seconds + remaining_workers + remaining_queued
  end

  def work(workers, graph, counts, seconds) do
    in_progress =
      workers
      |> Enum.filter(fn worker -> worker != nil end)
      |> Enum.map(fn {step, _} -> step end)

    if all_prerequisites_allocated?(graph, in_progress) do
      finish_up(workers, counts, seconds)
    else
      {workers, graph, counts, seconds} = tick(workers, graph, counts, in_progress, seconds)
      work(workers, graph, counts, seconds)
    end
  end

  def part1, do: input_to_graph() |> resolve_steps([]) |> Enum.join()

  def part2 do
    graph = input_to_graph()
    counts = count_predecessors(graph)
    workers = for _ <- 1..5, do: nil
    work(workers, graph, counts, 0)
  end
end

IO.puts(Day7.part1())
IO.puts(Day7.part2())
