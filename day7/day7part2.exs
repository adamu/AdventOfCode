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

  def input_to_tree(input) do
    input
    |> String.trim(".\n")
    |> String.split(".\n")
    |> Enum.map(&String.split(&1, " bags contain "))
    |> Map.new(fn [parent, child_spec] -> {parent, parse_children(child_spec)} end)
  end

  def parse_children(child_spec) when is_binary(child_spec) do
    child_spec
    |> String.split(", ")
    |> parse_children()
  end

  def parse_children(["no other bags"]), do: []

  def parse_children(list) do
    list
    |> Enum.map(&Regex.run(@bag_spec, &1, capture: :all_but_first))
    |> Enum.map(fn [count, type] -> {String.to_integer(count), type} end)
  end
end

Day7Part2.run()
