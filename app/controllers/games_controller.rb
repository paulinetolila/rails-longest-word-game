require 'open-uri'
require 'json'
require 'time'

class GamesController < ApplicationController
  def new
    grid = []
    i = 0
    until i == 10
      grid << ('A'..'Z').to_a.sample
      i += 1
    end
    @letters = grid
  end

  def score
    @result = {}
    # @result[:time] = @end_time - @start_time
    try = params[:word].upcase.chars
    letterisok = try.all? { |l| try.count(l) <= params[:letters].count(l) }
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    dictio_check = JSON.parse(open(url).read)
    if dictio_check['found'] == false
      @result[:message] = "Sorry but '#{params[:word].upcase}' is not an english word!"
      @result[:score] = 0
    elsif letterisok == true
      @result[:message] = 'Well done!'
      @result[:score] = try.count #.fdiv(end_time - start_time)
    elsif letterisok == false
      @result[:message] = "Sorry, the letters of '#{params[:word].upcase}' are not in #{params[:letters]}."
      @result[:score] = 0
    end
    @result
  end
end
