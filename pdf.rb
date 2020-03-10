require 'prawn'

def make_pdf(pdf_file, puz, info)
  Prawn::Document.generate( pdf_file , :info => info) do | pdf |
    pdf.stroke_axis if $debug
    # Title
    pdf.text "Word Search", :align => :center, :size => 20

    # Word Puzzle
    pdf.font("Courier") do
      pdf.pad(7) {
        for i in 0...puz.size
          line = ""
          for j in 0...puz.size
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

    pdf.start_new_page

    # Title
    pdf.text "Word Search - Key", :align => :center, :size => 20

    # Word Puzzle
    pdf.font("Courier") do
      pdf.pad(7) {
        for i in 0...puz.size
          line = ""
          for j in 0...puz.size
            # print each piece
            line << "#{puz.key_puzzle_board[i][j]}"
          end
          pdf.text "#{line}\n", :align => :center, :size => 9, :character_spacing => 5
        end
      }
    end

    #puts "pdf cursor is at #{pdf.cursor}" if $debug

    # Say what to do
    pdf.pad(20){
      pdf.text "The 45 words:",
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
end