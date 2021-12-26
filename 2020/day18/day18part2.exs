defmodule Day18Part2 do
  def run do
    File.stream!("input")
    |> Stream.map(&tokenize/1)
    |> Stream.map(&to_ast/1)
    |> Stream.map(&evaluate/1)
    |> Enum.sum()
    |> IO.puts()
  end

  def tokenize(line) do
    line
    |> String.graphemes()
    |> Stream.reject(fn char -> char in [" ", "\n"] end)
    |> Enum.map(fn
      symbol when symbol in ["*", "+", "(", ")"] -> symbol
      num -> {:num, String.to_integer(num)}
    end)
  end

  def to_ast(line), do: to_ast(line, nil, nil, [])
  def to_ast([], ast, nil, []), do: ast
  def to_ast([], ast, nil, later), do: ast_later(Enum.reverse([ast | later]), nil, nil)
  def to_ast(["+" | rest], left, nil, later), do: to_ast(rest, left, "+", later)
  def to_ast(["*" | rest], left, nil, later), do: to_ast(rest, nil, nil, ["*", left | later])

  def to_ast(["(" | rest], nil, op, later) do
    {new_left, rest} = to_ast(rest)
    to_ast(rest, new_left, op, later)
  end

  def to_ast(["(" | rest], left, op, later) do
    {new_left, rest} = to_ast(rest)
    to_ast([left | rest], new_left, op, later)
  end

  def to_ast([")" | rest], ast, nil, later) do
    ast = ast_later(Enum.reverse([ast | later]), nil, nil)
    {ast, rest}
  end

  def to_ast([ast | rest], nil, nil, later), do: to_ast(rest, ast, nil, later)
  def to_ast([right | rest], left, "+", later), do: to_ast(rest, {"+", left, right}, nil, later)

  def ast_later([], ast, nil), do: ast
  def ast_later(["*" | rest], left, nil), do: ast_later(rest, left, "*")
  def ast_later([left | rest], nil, nil), do: ast_later(rest, left, nil)
  def ast_later([right | rest], left, "*"), do: ast_later(rest, {"*", left, right}, nil)

  def evaluate({:num, num}), do: num
  def evaluate({"+", left, right}), do: evaluate(left) + evaluate(right)
  def evaluate({"*", left, right}), do: evaluate(left) * evaluate(right)
end

Day18Part2.run()
