defmodule Day4 do
  @log_pattern ~r/\[(\d\d\d\d-\d\d-\d\d \d\d:\d\d)\] (.+)/
  @guard_pattern ~r/Guard #(\d+) begins shift/

  def parse_log_line(str) do
    [date_str, entry] = Regex.run(@log_pattern, str, capture: :all_but_first)
    {:ok, date} = NaiveDateTime.from_iso8601(date_str <> ":00")
    {date, parse_entry(entry)}
  end

  def parse_entry("wakes up"), do: :wake
  def parse_entry("falls asleep"), do: :sleep

  def parse_entry(str) do
    [id] = Regex.run(@guard_pattern, str, capture: :all_but_first)
    {:arrive, String.to_integer(id)}
  end

  # [
  #   {~N[1518-02-18 00:08:00], :sleep, 131},
  #   {~N[1518-02-18 00:29:00], :wake, 131},
  #   ...
  # ]
  def parse_log() do
    File.stream!("input")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_log_line/1)
    |> Enum.sort(fn {d1, _}, {d2, _} -> NaiveDateTime.compare(d1, d2) === :lt end)
    |> Enum.map_reduce(nil, fn
      {date, {:arrive, id}}, _id -> {{date, :arrive, id}, id}
      {date, entry}, id -> {{date, entry, id}, id}
    end)
    |> elem(0)
    |> Enum.reject(fn {_date, event, _id} -> event === :arrive end)
  end

  def sleepy do
    parse_log()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [{sleep, _, _}, {wake, _, id}] ->
      {id, div(NaiveDateTime.diff(wake, sleep), 60)}
    end)
    |> Enum.group_by(fn {id, _mins} -> id end, fn {_id, mins} -> mins end)
    |> Enum.map(fn {id, mins} -> {id, Enum.sum(mins)} end)
    |> Enum.max_by(fn {_id, mins} -> mins end)
    |> elem(0)
  end

  def most_min_slept(guard_id) do
    parse_log()
    |> Enum.reject(fn {_date, _event, id} -> id !== guard_id end)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [{sleep, _, _}, {wake, _, _}] -> sleep.minute..(wake.minute - 1) end)
    |> Enum.reduce(%{}, fn range, freq_map ->
      Enum.reduce(range, freq_map, fn minute, freq_map ->
        Map.update(freq_map, minute, 1, &(&1 + 1))
      end)
    end)
    |> Enum.max_by(fn {_minute, freq} -> freq end)
    |> elem(0)
  end

  def part1 do
    sleepy = sleepy()
    most_min_slept = most_min_slept(sleepy)
    IO.puts("Guard most often asleep: #{sleepy}")
    IO.puts("Most mintutes that guard slept: #{most_min_slept}")
    IO.puts("Part 1 answer: #{sleepy * most_min_slept}")
  end

  def most_sleepy_guard_in(guard_freq_map) do
    Enum.max_by(guard_freq_map, fn {_id, freq} -> freq end)
  end

  def part2 do
    {minute, {id, _freq}} =
      parse_log()
      |> Enum.chunk_every(2)
      |> Enum.map(fn [{sleep, _, _}, {wake, _, id}] -> {id, sleep.minute..(wake.minute - 1)} end)
      |> Enum.reduce(%{}, fn {id, range}, minute_map ->
        Enum.reduce(range, minute_map, fn minute, minute_map ->
          Map.update(minute_map, minute, %{id => 1}, fn guard_map ->
            Map.update(guard_map, id, 1, &(&1 + 1))
          end)
        end)
      end)
      |> Enum.map(fn {minute, freq_map} -> {minute, most_sleepy_guard_in(freq_map)} end)
      |> Enum.max_by(fn {_minute, {_id, freq}} -> freq end)

    IO.puts("The guard that was most freequently alseep on the same minute: #{id}")
    IO.puts("The minute that guard was most frequently asleep on: #{minute}")
    IO.puts("Part 2 answer: #{id * minute}")
  end
end

Day4.part1()
Day4.part2()
