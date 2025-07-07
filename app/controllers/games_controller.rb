require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split(" ").map(&:upcase)
    @word_in_grid = word_in_grid?(@word, @letters)
    @word_included = word_included?(@word)
  end

  private

  def word_in_grid?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def word_included?(word)
      response = URI.open("https://dictionary.lewagon.com/#{word.downcase}")
      json = JSON.parse(response.read)

      @score = word.length
      if json["found"]
        @message = "Well done! Your score is #{@score}."
      else
        @score = 0
        @message = "Not a valid English word."
      end
  end
end
