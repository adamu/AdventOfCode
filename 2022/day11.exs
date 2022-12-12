defmodule Monkey do
  use GenServer

  defstruct [
    :num,
    :items_caught,
    :operation,
    :divisor,
    :true_monkey,
    :false_monkey,
    :inspected_count
  ]

  # Server
  #########

  def init(%Monkey{} = monkey) do
    {:ok, {monkey, _monkeys = %{}}}
  end

  def handle_cast({:catch, item}, {monkey, monkies}) do
    monkey = catch_item(monkey, item)
    {:noreply, {monkey, monkies}}
  end

  def handle_call({:register, monkies}, _from, {monkey, _monkies}) do
    {:reply, :ok, {monkey, monkies}}
  end

  def handle_call(:turn, _from, {monkey, monkies}) do
    monkey = do_business(monkey, monkies)
    {:reply, :done, {%Monkey{monkey | items_caught: []}, monkies}}
  end

  def handle_call(:get_count, _from, {monkey, monkies}) do
    {:reply, monkey.inspected_count, {monkey, monkies}}
  end

  # Client
  #########
  def throw(monkey, item), do: GenServer.cast(monkey, {:catch, item})
  def register(monkey, monkeys), do: GenServer.call(monkey, {:register, monkeys})
  def take_turn(monkey), do: GenServer.call(monkey, :turn)
  def report_count(monkey), do: GenServer.call(monkey, :get_count)

  # Monkey business
  ##################

  defp catch_item(monkey, item), do: %Monkey{monkey | items_caught: [item | monkey.items_caught]}

  defp do_business(monkey, monkies) do
    count =
      for item <- Enum.reverse(monkey.items_caught), reduce: 0 do
        count ->
          item = monkey.operation.(item) |> div(3)

          to_monkey =
            if rem(item, monkey.divisor) == 0 do
              monkey.true_monkey
            else
              monkey.false_monkey
            end

          throw(monkies[to_monkey], item)
          count + 1
      end

    %Monkey{monkey | items_caught: [], inspected_count: monkey.inspected_count + count}
  end
end

defmodule Day11 do
  def part1(input) do
    monkies = setup_monkies(input)
    order = monkies |> Map.keys() |> Enum.sort()

    run_rounds(20, monkies, order)

    order
    |> Enum.map(&Monkey.report_count(monkies[&1]))
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*/2)
  end

  def setup_monkies(input) do
    monkies =
      input
      |> Enum.with_index()
      |> Map.new(fn {monkey, idx} ->
        {:ok, pid} = GenServer.start_link(Monkey, monkey)
        {idx, pid}
      end)

    Enum.each(monkies, fn {_k, monkey} -> Monkey.register(monkey, monkies) end)

    monkies
  end

  defp run_rounds(0, _monkies, _order), do: :ok

  defp run_rounds(rounds, monkies, order) do
    Enum.each(order, &Monkey.take_turn(monkies[&1]))
    run_rounds(rounds - 1, monkies, order)
  end

  def part2(_input) do
    "not implemented"
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      input
      |> String.split("\n\n")
      |> Enum.map(fn monkey ->
        [
          <<"Monkey ", monkey_num::binary-1, ":">>,
          "Starting items: " <> starting_items,
          <<"Operation: new = old ", op::binary-1, " ", operand::binary>>,
          "Test: divisible by " <> divisor,
          "If true: throw to monkey " <> true_monkey,
          "If false: throw to monkey " <> false_monkey
        ] = monkey |> String.trim() |> String.split("\n") |> Enum.map(&String.trim/1)

        starting_items = String.split(starting_items, ", ")

        [monkey_num, divisor, true_monkey, false_monkey | starting_items] =
          Enum.map(
            [monkey_num, divisor, true_monkey, false_monkey] ++ starting_items,
            &String.to_integer/1
          )

        operation =
          case {op, operand} do
            {"+", "old"} -> fn old -> old + old end
            {"*", "old"} -> fn old -> old * old end
            {"+", operand} -> fn old -> old + String.to_integer(operand) end
            {"*", operand} -> fn old -> old * String.to_integer(operand) end
          end

        %Monkey{
          num: monkey_num,
          items_caught: Enum.reverse(starting_items),
          operation: operation,
          divisor: divisor,
          true_monkey: true_monkey,
          false_monkey: false_monkey,
          inspected_count: 0
        }
      end)
    else
      _ -> :error
    end
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
    IO.puts("Usage: elixir day11.exs input_filename")
  end
end

Day11.run()
