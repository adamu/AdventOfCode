defmodule Day7Part1 do
  @bag_spec ~r/\A(\d) (\w+ \w+).*\z/

  def run do
    File.read!("input")
    |> input_to_tree()
    |> invert_tree()
    |> count_ancestors("shiny gold")
    |> IO.puts()
  end

  def count_ancestors(itree, name), do: count_ancestors([name], MapSet.new(), itree)

  def count_ancestors([], bags, _itree), do: Enum.count(bags)

  def count_ancestors([name | rest], bags, itree) do
    case Map.fetch(itree, name) do
      :error -> count_ancestors(rest, bags, itree)
      {:ok, names} -> count_ancestors(names ++ rest, MapSet.union(bags, MapSet.new(names)), itree)
    end
  end

  # %{"shiny gold" => ["pale magenta", "striped tomato", ...]}
  def invert_tree(tree) do
    Enum.reduce(tree, %{}, fn {parent, children}, inverted_tree ->
      Enum.reduce(children, inverted_tree, fn {_n, child}, inverted_tree ->
        Map.update(inverted_tree, child, [parent], &[parent | &1])
      end)
    end)
  end

  # %{"shiny gold" => [{5, "pale brown"}, {2, "light red"}, {3, "drab lime"}]}
  def input_to_tree(input) do
    input
    |> String.split(".\n", trim: true)
    |> Enum.map(&String.split(&1, " bags contain "))
    |> Map.new(fn [parent, child_spec] -> {parent, parse_children(child_spec)} end)
  end

  def parse_children("no other bags"), do: []

  def parse_children(child_spec) do
    child_spec
    |> String.split(", ")
    |> Enum.map(&Regex.run(@bag_spec, &1, capture: :all_but_first))
    |> Enum.map(fn [count, type] -> {String.to_integer(count), type} end)
  end
end

Day7Part1.run()
