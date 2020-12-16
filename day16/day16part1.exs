defmodule Day16Part1 do
  def run do
    {rules, _my_ticket, tickets} =
      File.read!("input")
      |> parse_input()

    Enum.flat_map(tickets, &invalid_fields(&1, rules))
    |> Enum.sum()
    |> IO.puts()
  end

  def parse_input(input) do
    [rules, [_, my_ticket | _], [_ | nearby_tickets]] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules = Enum.map(rules, &parse_rule/1)

    [my_ticket | nearby_tickets] =
      [my_ticket | nearby_tickets]
      |> Enum.map(fn ticket -> String.split(ticket, ",") |> Enum.map(&String.to_integer/1) end)

    {rules, my_ticket, nearby_tickets}
  end

  def parse_rule(rule) do
    [name | ranges] =
      Regex.run(~r/\A(.*): (\d+)-(\d+) or (\d+)-(\d+)\z/, rule, capture: :all_but_first)

    [a, b, c, d] = Enum.map(ranges, &String.to_integer/1)
    {name, a..b, c..d}
  end

  def invalid_fields(ticket, rules) do
    Enum.reject(ticket, fn field ->
      Enum.any?(rules, fn {_name, range1, range2} -> field in range1 || field in range2 end)
    end)
  end
end

Day16Part1.run()
