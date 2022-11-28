defmodule Day4 do
  @rows for y <- 0..4, do: for(x <- 0..4, do: {x, y})
  @cols for x <- 0..4, do: for(y <- 0..4, do: {x, y})

  def part1(input) do
    {current_number, winning_board} = play(input)
    sum_unmarked(winning_board) * current_number
  end

  def play({_numbers = [], boards}), do: boards

  def play({[current_number | next_numbers], boards}) do
    boards = for board <- boards, do: mark(board, current_number)

    case check_for_winner(boards) do
      nil -> play({next_numbers, boards})
      board -> {current_number, board}
    end
  end

  def sum_unmarked(board) do
    board
    |> Enum.filter(&match?({_key, {_number, false}}, &1))
    |> Enum.map(fn {_key, {number, _marked}} -> number end)
    |> Enum.sum()
  end

  def mark(board, current_number) do
    case Enum.find(board, &match?({_key, {^current_number, false}}, &1)) do
      nil -> board
      {key, _value} -> Map.put(board, key, {current_number, true})
    end
  end

  def check_for_winner([]), do: nil

  def check_for_winner([board | boards]) do
    row_complete? =
      Enum.any?(@rows, fn row ->
        values = for key <- row, do: board[key]
        Enum.all?(values, &match?({_number, true}, &1))
      end)

    col_complete? =
      Enum.any?(@cols, fn col ->
        values = for key <- col, do: board[key]
        Enum.all?(values, &match?({_number, true}, &1))
      end)

    if row_complete? or col_complete? do
      board
    else
      check_for_winner(boards)
    end
  end

  def part2(_input) do
    :ok
  end

  def input do
    with [input_filename] <- System.argv(),
         {:ok, input} <- File.read(input_filename) do
      [numbers | boards] = String.split(input, "\n", trim: true)
      numbers = numbers |> String.split(",") |> Enum.map(&String.to_integer/1)
      boards = parse_boards(boards)
      {numbers, boards}
    else
      _ -> :error
    end
  end

  defp parse_boards([]), do: []

  defp parse_boards(boards) do
    {board, boards} = Enum.split(boards, 5)

    board = Enum.map(board, &String.split/1)

    board =
      for {row, y} <- Enum.with_index(board), {value, x} <- Enum.with_index(row), into: %{} do
        {{x, y}, {String.to_integer(value), false}}
      end

    [board | parse_boards(boards)]
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
    IO.puts("Usage: elixir day4.exs input_filename")
  end
end

# Day4.run()
