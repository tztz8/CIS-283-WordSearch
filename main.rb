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
require 'prawn'
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
Prawn::Document.generate( pdf_file , :info => info) do | pdf |
  pdf.stroke_axis if $debug
  # Title
  pdf.text "Word Search", :align => :center, :size => 20

  # Word Puzzle
  pdf.font("Courier") do
    pdf.pad(7) {
      for i in 0...size
        line = ""
        for j in 0...size
          # print each piece
          line << "#{puz.puzzle_board[i][j]}"
        end
        pdf.text "#{line}\n", :align => :center, :size => 9, :character_spacing => 5
      end
    }
  end

  #puts "pdf cursor is at #{pdf.cursor}" if $debug

  # Say what to do
  pdf.pad(20){
    pdf.text "Find the following 45 words:",
             :align => :center, :size => 9
  }
  # list all the words
  pdf.column_box([0, pdf.cursor], :columns => 3, :width => pdf.bounds.width) do
    puz.words.each { |word|
      pdf.pad(1){
        pdf.text word,
                 :align => :center, :size => 7.5
      }
    }
  end
end