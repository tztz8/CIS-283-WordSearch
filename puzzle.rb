#####################################################################################
#
#  Name:        Timbre Freeman
#  Assignment:  Final - Word Search Maker - Puzzle Class
#  Date:        03/03/2020
#  Class:       CIS 283
#  Description: Make a program that make a word search in a pdf for a list of words
#
#####################################################################################

class Puzzle
  attr_reader :puzzle_board, :debug, :size
  @@char_blank = "."

  def initialize (size, word_file_name, debug = false)
    @debug = debug
    @size = size
    @words_orginal = get_words(word_file_name)
    puts @words_orginal.inspect if @debug
    @words = (@words_orginal[1].sort_by{ |x| x.length }).reverse
    puts @words.inspect if @debug
    @puzzle_board = Array.new(@size) {Array.new(@size, @@char_blank)}
    @words_data = Array.new(@words.length) {Array.new(3)}
  end

  def words
    return @words_orginal[0]
  end

  def make_puzzle
    for i in 0...@words.length
      place_word_in_puzzle(i)
    end
    # adding random letters
    # puzzle_board.each do |line|
    #   line.each do |char|
    #     if char == @@char_blank
    #       char = rand()
    #     end
    #   end
    # end
  end

  def restart
    @puzzle_board = Array.new(@size) {Array.new(@size, @@char_blank)}
    @words_data = Array.new(@words.length) {Array.new(3)}
  end

  def puzzle_board_as_string
    return_string = ""
    for i in 0...@size
      for j in 0...@size
        # print each piece
        return_string << "#{@puzzle_board[i][j]}"
      end
      return_string << "\n"
    end
    return return_string
  end

  private
    def get_words(word_file_name)
      words = Array.new(2) {Array.new()}
      word_file = File.open(word_file_name, "r")
      word_file.each do |word|
        words[0].push(word.chomp)
        words[1].push(word.chomp.downcase)
      end
      return words
    end
    def set_word_data(word_index)
      @words_data[word_index][2] = ["Horizontal", "Vertical", "Diagonal", "Diagonal-Left",
                                    "Horizontal-Flip", "Vertical-Flip", "Diagonal-Flip", "Diagonal-Left-Flip"].sample
      @words_data[word_index][0] = angle_out(@words[word_index], @words_data[word_index][2])
      puts "#{@words[word_index]} rotation is #{@words_data[word_index][2]} | output:#{@words_data[word_index][0]}" if @debug
      #word_placement = (@size/@words[word_index].length)
      #puts "#{@words[word_index]} word_placement = #{word_placement}" if @debug
      #@words_data[word_index][1] = [(rand(0...word_placement))*@words[word_index].length, (rand(0...word_placement))*@words[word_index].length]
      @words_data[word_index][1] = [rand(0...@size-@words[word_index].length), rand(0...@size-@words[word_index].length)]
      puts "#{@words[word_index]} at (#{@words_data[word_index][1][0]},#{@words_data[word_index][1][1]})" if @debug
    end
    def place_word_in_puzzle(word_index)
      works = false
      while !works
        puzzle_board = Marshal.load(Marshal.dump(@puzzle_board))
        set_word_data(word_index)
        works = true
        @words_data[word_index][0].each_with_index do |list, x|
          if !works
            break
          end
          list.each_with_index do |char, y|
            print ("(#{(@words_data[word_index][1][0])+x},#{(@words_data[word_index][1][1])+y}) is #{char}") if @debug
            if puzzle_board[(@words_data[word_index][1][0])+x][(@words_data[word_index][1][1])+y] == @@char_blank
              puzzle_board[(@words_data[word_index][1][0])+x][(@words_data[word_index][1][1])+y] = char
            elsif puzzle_board[(@words_data[word_index][1][0])+x][(@words_data[word_index][1][1])+y] == char

            else
              puts "" if @debug
              puts "Fail (#{(@words_data[word_index][1][0])+x},#{(@words_data[word_index][1][1])+y}) want #{char} is #{puzzle_board[(@words_data[word_index][1][0])+x][(@words_data[word_index][1][1])+y]} retrying" if @debug
              works = false
              break
            end
          end
        end
        puts "" if @debug
        #sleep(1) if !works && @debug
      end
      @puzzle_board = puzzle_board
    end
    def angle_out(word, angle)
      word_chars = word.chars
      #@letters.append(word_chars)
      size = word_chars.length
      output = Array.new(size) {Array.new(size, @@char_blank)}
      #puts output.inspect if @debug
      if angle == "Horizontal"
        word_chars.each_with_index do |char, i|
          output[i][0] = char
        end
      elsif angle == "Vertical"
        word_chars.each_with_index do |char, i|
          output[0][i] = char
        end
      elsif angle == "Diagonal"
        word_chars.each_with_index do |char, i|
          output[i][i] = char
        end
      elsif angle == "Diagonal-Left"
        word_chars.each_with_index do |char, i|
          output[i][size-(i+1)] = char
        end
      elsif angle == "Horizontal-Flip"
        return angle_out(word.reverse, "Horizontal")
      elsif angle == "Vertical-Flip"
        return angle_out(word.reverse, "Vertical")
      elsif angle == "Diagonal-Flip"
        return angle_out(word.reverse, "Diagonal")
      elsif angle == "Diagonal-Left-Flip"
        return angle_out(word.reverse, "Diagonal-Left")
      end
      #puts output.inspect if @debug
      return output
    end
end