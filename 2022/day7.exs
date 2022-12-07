defmodule Day7 do
  @root ["/"]
  @total_size 70_000_000
  @space_needed 30_000_000

  def part1(input) do
    store = build_tree(input)

    [@root]
    |> build_queue([], store)
    |> Enum.reduce(store, &update_dir_size/2)
    |> Enum.filter(fn
      {_k, {:dir, size, _paths}} -> size <= 100_000
      _ -> false
    end)
    |> Enum.map(fn {_k, {_type, size, _paths}} -> size end)
    |> Enum.sum()
  end

  def update_dir_size(path, store) do
    {:dir, 0, paths} = Map.get(store, path)
    size = store |> Map.take(paths) |> Enum.map(fn {_, {_, size, _}} -> size end) |> Enum.sum()
    Map.put(store, path, {:dir, size, paths})
  end

  def build_queue([], queue, _store), do: queue

  def build_queue([node | rest], queue, store) do
    case Map.get(store, node) do
      {:file, _size, nil} -> build_queue(rest, queue, store)
      {:dir, _size, paths} -> build_queue(paths ++ rest, [node | queue], store)
    end
  end

  def build_tree(input, path \\ [], store \\ %{})
  def build_tree([], _path, store), do: store
  def build_tree([{:cd, "/"} | rest], _path, store), do: build_tree(rest, @root, store)
  def build_tree([{:cd, ".."} | rest], [_here | path], store), do: build_tree(rest, path, store)
  def build_tree([{:cd, dir} | rest], path, store), do: build_tree(rest, [dir | path], store)

  def build_tree([{:ls, items} | rest], path, store) do
    # insert files into store with directory path
    {paths, store} =
      Enum.map_reduce(items, store, fn
        {:dir, name}, store ->
          item_path = [name | path]
          {item_path, Map.put(store, item_path, {:dir, 0, []})}

        {:file, size, name}, store ->
          item_path = [name | path]
          {item_path, Map.put(store, item_path, {:file, size, nil})}
      end)

    store = Map.put(store, path, {:dir, 0, paths})

    build_tree(rest, path, store)
  end

  def part2(input) do
    store = build_tree(input)

    store =
      [@root]
      |> build_queue([], store)
      |> Enum.reduce(store, &update_dir_size/2)

    {:dir, space_used, _} = Map.get(store, @root)
    unused_space = @total_size - space_used
    space_to_free = @space_needed - unused_space

    {_dir, size} =
      store
      |> Enum.filter(&match?({_path, {:dir, _size, _paths}}, &1))
      |> Enum.map(fn {[name | _], {:dir, size, _paths}} -> {name, size} end)
      |> Enum.sort_by(fn {_name, size} -> size end)
      |> Enum.find(fn {_name, size} -> size >= space_to_free end)

    size
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.trim()
      |> String.split("\n")
      |> parse_input()
    else
      _ -> :error
    end
  end

  def parse_input([]), do: []
  def parse_input(["$ cd " <> dir | rest]), do: [{:cd, dir} | parse_input(rest)]

  def parse_input(["$ ls" | rest]) do
    {listings, rest} = Enum.split_while(rest, &(!match?("$" <> _, &1)))

    listings =
      Enum.map(listings, fn
        "dir " <> dir ->
          {:dir, dir}

        file ->
          [size, name] = String.split(file)
          {:file, String.to_integer(size), name}
      end)

    [{:ls, listings} | parse_input(rest)]
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
    IO.puts("Usage: elixir day7.exs input_filename")
  end
end

Day7.run()
