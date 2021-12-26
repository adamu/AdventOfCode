defmodule Part2 do
  def count_diffs(str1, str2) do
    Stream.zip(String.to_charlist(str1), String.to_charlist(str2))
    |> Enum.count(fn {a, b} -> a !== b end)
  end

  def common_chars(str1, str2) do
    Stream.zip(String.to_charlist(str1), String.to_charlist(str2))
    |> Stream.filter(fn {a, b} -> a === b end)
    |> Enum.map(fn {a, _b} -> a end)
  end

  def run do
    boxes = File.stream!("input") |> Enum.map(&String.trim/1)

    diffs =
      for box <- boxes, other_box <- boxes -- [box] do
        {box, count_diffs(box, other_box)}
      end

    [str1, str2] =
      diffs
      |> Enum.filter(fn {_box, diff} -> diff === 1 end)
      |> Enum.map(fn {box, 1} -> box end)

    IO.puts(common_chars(str1, str2))
  end
end

Part2.run()
