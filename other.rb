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