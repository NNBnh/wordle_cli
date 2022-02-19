# frozen_string_literal: true

require_relative "wordle_cli/version"
require_relative "wordle_cli/word_list"

module WordleCli
  class Error < StandardError; end

  def self.play(word = @@word_list.select { |word| word.length == 5 } .sample, guess: 6)
    word = word.to_s if word.is_a?(Symbol)

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
        print "\e[1m", ">".ljust(padding), "\e[m"
        guess_word = gets.chomp.downcase

        break if guess_word_list.include?(guess_word)

        print "\e[A\e[?7l", " " * guess_word.size * 4, "\e[?7h\n\e[A"
      end

      print "\e[A\e[37m", (guess_count + 1).to_s.ljust(padding), "\e[m"

      guess_word.chars.each_with_index do |char, index|
        if char == word[index]
          print "\e[0;1;30;102m"
        elsif word.include? char
          print "\e[0;30;103m"
        else
          print "\e[0;100m"
        end

        print "#{char}"
      end

      puts "\e[m"

      return if guess_word == word
    end

    return word
  end
end
