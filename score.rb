`time ruby main.rb > results.txt`

count = 0

require 'json'
IO.readlines("results.txt").each do |line|
  count += JSON[line]['listings'].size
end

warn count
