require 'open-uri'
require 'nokogiri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters].split
    @word_letters = params[:word].upcase.split('')
    @total = []
    check_word(@word_letters)
    check_dictionary(params[:word])
    determine_score(params[:word].upcase)
    @total << @score[:score]
  end

  private

  def determine_score(word)
    @score = if @word_letters.include?(false)
               { message: "Sorry but #{word} can't be built from #{@letters}",
                 score: 0 }
             elsif @result['found'] == false
               { message: "Sorry but #{word} isn't an english word!",
                 score: 0 }
             else
               { message: "Nice! #{word} is a valid word!",
                 score: @word_letters.length }
             end
  end

  def check_word(letters)
    letters.each_with_index do |letter, index|
      letters[index] = @letters.include?(letter)
    end
  end

  def check_dictionary(word)
    url = open("https://wagon-dictionary.herokuapp.com/#{word}")
    doc = Nokogiri::HTML(url)
    @result = JSON.parse(doc)
  end
end
