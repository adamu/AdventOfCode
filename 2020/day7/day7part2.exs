defmodule Day7Part2 do
  @bag_spec ~r/\A(\d) (\w+ \w+).*\z/

  def run do
    File.read!("input")
    |> input_to_tree()
    |> count_descendants("shiny gold")
    |> IO.puts()
  end

  def count_descendants(tree, name) do
    Enum.reduce(tree[name], 0, fn {size, child_name}, count ->
      count + size + size * count_descendants(tree, child_name)
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

Day7Part2.run()
