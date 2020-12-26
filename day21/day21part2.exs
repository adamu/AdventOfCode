defmodule DayDay21Part2 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, [" (contains ", ", ", ")"], trim: true))
    |> Enum.map(fn [ingredients | allergens] -> {String.split(ingredients), allergens} end)
    |> Enum.reduce(%{}, fn {ingredients, allergens}, acc ->
      ingredients = MapSet.new(ingredients)

      Enum.reduce(allergens, acc, fn allergen, acc ->
        Map.update(acc, allergen, ingredients, &MapSet.intersection(&1, ingredients))
      end)
    end)
    |> Map.new(fn {allergen, ingredients} -> {allergen, MapSet.to_list(ingredients)} end)
    |> resolve_ingredients([])
    |> Enum.sort_by(fn {allergen, _ingredient} -> allergen end)
    |> Enum.map(fn {_allergen, ingredient} -> ingredient end)
    |> Enum.join(",")
    |> IO.puts()
  end

  def resolve_ingredients(suspected, resolved) when map_size(suspected) == 0, do: resolved

  def resolve_ingredients(suspected, resolved) do
    {allergen, [ingredient]} =
      Enum.find(suspected, fn {_allergen, ingredients} -> length(ingredients) == 1 end)

    IO.puts("#{ingredient} contains #{allergen}")

    suspected =
      suspected
      |> Map.delete(allergen)
      |> Map.new(fn {allergen, ingredients} -> {allergen, ingredients -- [ingredient]} end)

    resolved = [{allergen, ingredient} | resolved]

    resolve_ingredients(suspected, resolved)
  end
end

DayDay21Part2.run()
