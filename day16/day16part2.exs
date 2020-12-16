defmodule Day16Part2 do
  def run do
    {rules, my_ticket, tickets} = File.read!("input") |> parse_input()

    tickets
    |> Enum.filter(&valid?(&1, rules))
    |> transpose_tickets()
    |> identify_columns(rules)
    |> Enum.filter(&match?({"departure" <> _, _idx}, &1))
    |> Enum.reduce(1, fn {_name, idx}, acc -> my_ticket[idx] * acc end)
    |> IO.puts()
  end

  def valid?(ticket, rules) do
    Enum.all?(ticket, fn field ->
      Enum.any?(rules, fn {_name, {range1, range2}} -> field in range1 || field in range2 end)
    end)
  end

  def transpose_tickets(tickets), do: transpose_tickets(tickets, [], 0, length(hd(tickets)))
  def transpose_tickets(_tickets, columns, stop, stop), do: columns

  def transpose_tickets(tickets, columns, field_index, stop) do
    {remaining_columns, column} = next_column(tickets)

    transpose_tickets(remaining_columns, [{field_index, column} | columns], field_index + 1, stop)
  end

  def next_column(tickets) do
    Enum.map_reduce(tickets, [], fn [field | rest], column -> {rest, [field | column]} end)
  end

  # Probably overcomplicated this.
  # First find which columns satisfy which rules.
  # The number of valid fields for each column is unique, which doesn't seem like a coincidence.
  # Then allocate the columns to fields starting from the column with the smallest number
  # of valid columns - need to filter out the known values for the rest of the columns.
  # It's the final filtering part that makes me think I'm missing a trick.
  def identify_columns(transposed_tickets, rules) do
    {field_map, by_valid_count} =
      Enum.reduce(transposed_tickets, {%{}, %{}}, fn {id, column}, {field_map, by_valid_count} ->
        names = names_for(column, rules)
        valid_count = length(names)

        {Map.put(field_map, id, names), Map.put(by_valid_count, valid_count, id)}
      end)

    {identified, _seen} =
      by_valid_count
      |> Enum.sort(fn {k1, _}, {k2, _} -> k1 <= k2 end)
      |> Enum.reduce({%{}, MapSet.new()}, fn {_, col}, {identified, seen} ->
        field = field_map[col] |> MapSet.new() |> MapSet.difference(seen) |> Enum.at(0)
        {Map.put(identified, field, col), MapSet.put(seen, field)}
      end)

    identified
  end

  def names_for(column, rules) do
    Enum.filter(rules, fn {_field, {range1, range2}} ->
      Enum.all?(column, fn val -> val in range1 || val in range2 end)
    end)
    |> Enum.map(&elem(&1, 0))
  end

  def parse_input(input) do
    [rules, [_, my_ticket | _], [_ | nearby_tickets]] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules = Map.new(rules, &parse_rule/1)

    [my_ticket | nearby_tickets] =
      [my_ticket | nearby_tickets]
      |> Enum.map(fn ticket -> String.split(ticket, ",") |> Enum.map(&String.to_integer/1) end)

    my_ticket = my_ticket |> Enum.with_index() |> Map.new(fn {val, idx} -> {idx, val} end)

    {rules, my_ticket, nearby_tickets}
  end

  def parse_rule(rule) do
    [name | ranges] =
      Regex.run(~r/\A(.*): (\d+)-(\d+) or (\d+)-(\d+)\z/, rule, capture: :all_but_first)

    [a, b, c, d] = Enum.map(ranges, &String.to_integer/1)
    {name, {a..b, c..d}}
  end
end

Day16Part2.run()
