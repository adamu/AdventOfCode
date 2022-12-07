defmodule Day7 do
  @root ["/"]

  def part1(input) do
    input
    |> filetree_with_dir_sizes()
    |> Enum.filter(fn
      {_k, {:dir, size, _paths}} -> size <= 100_000
      {_k, {:file, _size, _paths}} -> false
    end)
    |> Enum.map(fn {_k, {_type, size, _paths}} -> size end)
    |> Enum.sum()
  end

  defp filetree_with_dir_sizes(input) do
    tree = build_tree(input)

    tree
    |> dirs_fewest_descendents_first()
    |> Enum.reduce(tree, &put_dir_size/2)
  end

  defp put_dir_size(path, tree) do
    {:dir, nil, paths} = tree[path]
    size = tree |> Map.take(paths) |> Enum.map(fn {_, {_, size, _}} -> size end) |> Enum.sum()
    Map.put(tree, path, {:dir, size, paths})
  end

  defp dirs_fewest_descendents_first(tree, to_check \\ [@root], found_dirs \\ [])
  defp dirs_fewest_descendents_first(_tree, [], found_dirs), do: found_dirs

  defp dirs_fewest_descendents_first(tree, [node | rest], dirs) do
    case tree[node] do
      {:file, _size, nil} -> dirs_fewest_descendents_first(tree, rest, dirs)
      {:dir, _size, paths} -> dirs_fewest_descendents_first(tree, paths ++ rest, [node | dirs])
    end
  end

  defp build_tree(input, path \\ [], tree \\ %{})
  defp build_tree([], _path, tree), do: tree
  defp build_tree([{:cd, "/"} | rest], _path, tree), do: build_tree(rest, @root, tree)
  defp build_tree([{:cd, ".."} | rest], [_here | path], tree), do: build_tree(rest, path, tree)
  defp build_tree([{:cd, dir} | rest], path, tree), do: build_tree(rest, [dir | path], tree)

  defp build_tree([{:ls, items} | rest], path, tree) do
    {paths, tree} =
      Enum.map_reduce(items, tree, fn
        # Create an empty directory for each dir listed
        # (needed if we we forget to ls inside a dir)
        {:dir, nil, name}, tree ->
          item_path = [name | path]
          {item_path, Map.put(tree, item_path, {:dir, nil, []})}

        # Create a file for each file listed
        {:file, size, name}, tree ->
          item_path = [name | path]
          {item_path, Map.put(tree, item_path, {:file, size, nil})}
      end)

    # Create current directory with listed children
    tree = Map.put(tree, path, {:dir, nil, paths})

    build_tree(rest, path, tree)
  end

  @total_size 70_000_000
  @space_needed 30_000_000

  def part2(input) do
    tree = filetree_with_dir_sizes(input)

    {:dir, space_used, _} = tree[@root]
    unused_space = @total_size - space_used
    space_to_free = @space_needed - unused_space

    tree
    |> Enum.filter(&match?({_path, {:dir, _size, _paths}}, &1))
    |> Enum.map(fn {_path, {:dir, size, _paths}} -> size end)
    |> Enum.sort()
    |> Enum.find(fn size -> size >= space_to_free end)
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

  defp parse_input([]), do: []
  defp parse_input(["$ cd " <> dir | rest]), do: [{:cd, dir} | parse_input(rest)]

  defp parse_input(["$ ls" | rest]) do
    {listings, rest} = Enum.split_while(rest, &(!match?("$" <> _, &1)))

    listings =
      Enum.map(listings, fn
        "dir " <> dir ->
          {:dir, nil, dir}

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
