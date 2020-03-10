# lib
require './puzzle.rb'
#require 'prawn'

# Debugging flag
$debug = true

# Var for making the puzzle
size = 45
file = "words.txt"
puz = Puzzle.new(size, file, $debug)

full_time = Time.now  # timer for how long it takes making the puzzle
while (Time.now - full_time) <= 0.1
  time_start = Time.now
  full_time = Time.now
  make_puzzle_thr = Thread.new {
    puz.make_puzzle
  }

  exit_thr = Thread.new { # allow us to exit the program
    while gets.chomp != "y"
      puts "still running"
    end
    make_puzzle_thr.exit
  }

  while make_puzzle_thr.status == "run" # check if the we are still making the puzzle
    print ". " if !$debug
    sleep(1) if !$debug
    if (Time.now - time_start) >= 10
      puts ""
      puts "Too Long - retrying"
      time_start = Time.now
      make_puzzle_thr.exit
      puz.restart
      make_puzzle_thr = Thread.new {
        puz.make_puzzle
      }
    end
  end
  puts ""
  # close both threads
  make_puzzle_thr.exit
  exit_thr.exit
  puts "Finish Making Puzzle at #{Time.now - full_time}"
end
