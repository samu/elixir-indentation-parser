filename = "test.txt"

stream = File.stream!(filename)

stack = []

defmodule IndentationParser do
  def read_lines(stream) do
    stream
    |>  Enum.with_index
    |>  Enum.map fn({line, index}) ->
          length = ~r/^[ ]*/
          |>  Regex.run(line)
          |>  hd
          |>  String.length
          %{length: length, line: line, index: index}
        end
  end

  def get_indentation_difference(a, b) do
    a.length - b.length
  end

  def run(stream) do
    [head | tail] = read_lines(stream)
    process_line(tail, head)
  end

  def process_line([], _) do
    IO.inspect "done"
    []
  end

  def process_line(lines, previous_line) do
    [current_line | tail] = lines

    diff = get_indentation_difference(previous_line, current_line)
    lines = handle_indentation(diff, lines, previous_line, current_line)

    if  diff < 0 do
      lines = process_line(lines, previous_line)
    end

    lines
  end

  def handle_indentation(diff, lines, previous_line, current_line) when diff < 0 do
    IO.inspect "--- top < current"
    IO.inspect previous_line
    IO.inspect current_line
    IO.inspect "------------------"
    IO.inspect ""
    process_line(tl(lines), current_line)
  end

  def handle_indentation(diff, lines, previous_line, current_line) when diff > 0 do
    if current_line.index - previous_line.index == 1 do
      IO.inspect "found a leaf node! #{previous_line.line}"
    end
    lines
  end

  def handle_indentation(diff, lines, previous_line, current_line) do
    if current_line.index - previous_line.index == 1 do
      IO.inspect "found a leaf node! #{previous_line.line}"
    end
    lines
  end

  def set_up_handler(handlers, regex, callback) do
    [%{regex: regex, callback: callback} | handlers]
  end
end

handlers = []
  |> IndentationParser.set_up_handler(1, 2)
  |> IndentationParser.set_up_handler(1, 2)
  |> IndentationParser.set_up_handler(1, 2)

IO.inspect IndentationParser.run(stream)
