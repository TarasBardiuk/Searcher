class StaticPagesController < ApplicationController
  def home
    @data = value_upcase(JSON.parse(File.read('data.json')))
    if params[:query]
      query = params[:query].upcase.split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
      query.each do |search_word|
        @data = filter(@data, search_word)
      end
    end
  end

  private

  def filter(data_array, word)
    matched = []
    word = word[1..-2] if word.include?('"')
    data_array.each do |hash|
      if word.chars.first == '-'
        unless hash.except(:relevance)
                   .any? { |key, value| value.include? word[1..-1] }
          matched << relevance(hash, word)
        end
      elsif hash.except(:relevance).any? { |key, value| value.include? word }
        matched << relevance(hash, word)
      end
    end
    matched.sort_by { |k| [-k[:relevance], k['Name']] }
  end

  def relevance(hash, word)
    hash[:relevance] = 0
    hash[:relevance] += hash['Name'].include?(word) ? 3 :
                          hash['Type'].include?(word) ? 2 :
                            hash['Designed by'].include?(word) ? 1 : 0
    hash
  end

  def value_upcase(data_array)
    data_array.each do |hash|
      hash.each { |k, v| v.upcase! }
    end
  end
end
