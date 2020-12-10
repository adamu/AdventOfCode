defmodule DayREPLACE_MEPart1 do
  def run do
    File.read!("input")
    |> String.split("\n", trim: true)
  end
end

DayREPLACE_MEPart1.run()
