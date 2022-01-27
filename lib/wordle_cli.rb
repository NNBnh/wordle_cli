# frozen_string_literal: true

require_relative "wordle_cli/version"
require_relative "wordle_cli/word_list"

module WordleCli
  class Error < StandardError; end

  def play(word = @@word_list.select { |word| word.length == 5 } .sample, guess: 6)
    word_length = word.is_a?(String) ? word.length : 0

    if word.is_a?(Integer)
      word_length = word
      word = @@word_list.select { |word| word.length == word_length } .sample
    end

    guess_word_list = @@word_list.select { |word| word.length == word_length }

    guess.times do |guess_count|
      padding = guess.to_s.length + 1
      guess_word = nil

      loop do
        print "\033[1m", ">".ljust(padding), "\033[m"
        guess_word = gets.chomp.downcase

        break if guess_word_list.include?(guess_word)

        print "\033[A\033[?7l", " " * guess_word.size * 4, "\033[?7h\n\033[A"
      end

      print "\033[A\033[37m", (guess_count + 1).to_s.ljust(padding), "\033[m"

      guess_word.chars.each_with_index do |char, index|
        if char == word[index]
          print "\033[0;1;30;102m"
        elsif word.include? char
          print "\033[0;30;103m"
        else
          print "\033[0;100m"
        end

        print "#{char}"
      end

      puts "\033[m"

      return if guess_word == word
    end

    return word
  end
end
