#####################################################################################
#
#  Name:        Timbre Freeman
#  Assignment:  Final - Word Search Maker
#  Date:        03/03/2020
#  Class:       CIS 283
#  Description: Make a program that make a word search in a pdf for a list of words
#
#####################################################################################

# lib
require './puzzle.rb'
require './pdf.rb'
#require 'prawn/table'

# Debugging flag
$debug = false

# Var for making the puzzle
size = 45
file = "words.txt"
info = {
    :Title    => "Word Puzzle",
    :Author   => "Timbre Freeman",
    :Subject  => "CIS 283 - Final Project - Output"
}
pdf_file = "Test.pdf"
puz = Puzzle.new(size, file, $debug)
Thread.abort_on_exception = true

# ***Make the Puzzle***
puts "Welcome to Puzzle maker"
puts "***preset y and than enter to end program***"
print "Making puzzle "

time_start = Time.now  # timer for how long it takes making the puzzle
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
puts "Finish Making Puzzle at #{Time.now - time_start}"

puts puz.puzzle_board_as_string if $debug

puts "Making #{pdf_file}"
make_pdf(pdf_file, puz, info)