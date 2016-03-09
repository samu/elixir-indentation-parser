require 'listen'

listener = Listen.to('.') do |modified, added, removed|
  puts "----------"
  puts `elixir main.exs`
end
listener.start # not blocking
sleep
