filename = "test.txt"

stream = File.stream!(filename)

stack = []

defmodule IndentationParser do
  def read_lines(stream) do
    Enum.map stream, fn(line)  ->
      length = ~r/^[ ]*/
        |> Regex.run(line)
        |> hd
        |> String.length
      %{length: length, line: line}
    end
  end

  def get_indentation_difference(a, b) do
    a.length - b.length
  end

  def run(stream) do
    [head | tail] = read_lines(stream)
    process_line(tail, [head])
  end

  def process_line([], _) do
    IO.inspect "done"
  end

  def process_line(lines, stack) do
    [next_line | tail] = lines

    get_indentation_difference(hd(stack), next_line)
      |> handle_indentation(next_line, hd(stack))

    process_line(tail, [next_line | stack])
  end

  def handle_indentation(diff, line, stack_head) when diff < 0 do
    IO.inspect "top < current"
  end

  def handle_indentation(diff, line, stack_head) when diff > 0 do
    IO.inspect "top > current"
  end

  def handle_indentation(diff, line, stack_head) do
    IO.inspect "top = current"
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
