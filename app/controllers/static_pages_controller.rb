class StaticPagesController < ApplicationController
  def home
    @data = JSON.parse(File.read('data.json'))
    if params[:query]
      query = params[:query].split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
      query.each do |search_word|
        @data = filter(@data, search_word)
      end
    end
  end

  def search
    @filtered = []
    query = params[:query].split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
    @data = JSON.parse(File.read('data.json'))
    query.each do |search_word|
      @data = filter(@data, search_word)
    end
    puts @data
  end

  private

  def filter(data_array, word)
    matched = []
    word = word.include?('"') ? word[1..-2].downcase : word.downcase
    data_array.each do |hash|
      if word.chars.first == '-'
        unless hash.any? { |key, value| value.downcase.include? word[1..-1] }
          matched << hash
        end
      elsif hash.any? { |key, value| value.downcase.include? word }
        matched << hash
      end
    end
    matched
  end
end
