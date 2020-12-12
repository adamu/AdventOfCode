defmodule DayREPLACE_MEPart1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
    |> IO.inspect()
  end
end

DayREPLACE_MEPart1.run()
