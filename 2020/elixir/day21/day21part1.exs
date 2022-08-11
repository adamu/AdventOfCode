defmodule DayDay21Part1 do
  def run do
    input =
      File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, [" (contains ", ", ", ")"], trim: true))
      |> Enum.map(fn [ingredients | allergens] -> {String.split(ingredients), allergens} end)

    known_allergens =
      input
      |> Enum.reduce(%{}, fn {ingredients, allergens}, acc ->
        ingredients = MapSet.new(ingredients)

        Enum.reduce(allergens, acc, fn allergen, acc ->
          Map.update(acc, allergen, ingredients, &MapSet.intersection(&1, ingredients))
        end)
      end)
      |> Enum.sort_by(fn {_allergen, ingredients} -> Enum.count(ingredients) end)

    all_ingredients = Enum.flat_map(input, fn {ingredients, _allergens} -> ingredients end)

    contains_allergens =
      known_allergens
      |> Enum.map(fn {_allergen, ingredients} -> ingredients end)
      |> Enum.reduce(&MapSet.union/2)

    no_allergens =
      all_ingredients
      |> MapSet.new()
      |> MapSet.difference(contains_allergens)
      |> MapSet.to_list()

    all_ingredients
    |> Enum.frequencies()
    |> Map.take(no_allergens)
    |> Map.values()
    |> Enum.sum()
    |> IO.inspect()
  end
end

DayDay21Part1.run()
