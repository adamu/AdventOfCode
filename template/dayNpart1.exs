defmodule DayREPLACE_MEPart1 do
  def run do
    File.read!("input")
    |> String.trim()
    |> String.split("\n")
  end
end

DayREPLACE_MEPart1.run()
