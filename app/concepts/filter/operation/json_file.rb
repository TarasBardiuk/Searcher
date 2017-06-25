require 'trailblazer/operation'

module Filter
  class JSONFile < Trailblazer::Operation
    step :get_data
    step :fill_data

    def get_data(options, params:, **)
      # Read and parse JSON-file, and transform all hash values to uppercase
      options['data'] = value_upcase(JSON.parse(File.read('data.json')))
      # If search query exists, next step 'fill_data' will be executed
      params[:query]
      # Otherwise operation stops
    end

    def fill_data(options, params:, **)
      # Split search query using regex, which also handles input with double
      # quotes
      query = params[:query].upcase.split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
      query.each do |word|
        word = unquote(word)
        options['data'] = matcher(options['data'], word)
      end
    end

    private

    def value_upcase(data_array)
      # Used for case-insensitive search.
      data_array.each do |hash|
        hash.each { |k, v| v.upcase! }
      end
    end

    def unquote(word)
      # Used for double quotes deletion around the search query
      word[0] == ('"') && word[-1] == ('"') ? word[1..-2] : word
    end

    def matcher(data_array, word)
      matched = []
      data_array.each do |hash|
        # (if word from search query starts with "-" AND isn't present in hash)
        # OR (if word present in hash) - push hash into array
        matched << relevance(hash, word) if (word.chars.first == '-' &&
          !hash_includes(hash, word[1..-1])) || hash_includes(hash, word)
      end
      # Sorting array of hashes by values of each ':relevance' field, and by
      # each 'Name' field
      matched.sort_by { |k| [-k[:relevance], k['Name']] }
    end

    def hash_includes(hash, word)
      # Check if 'hash' includes 'word' in any field, but '.except(:relevance)'
      # That field will be added when user will print first character.
      hash.except(:relevance).any? { |key, value| value.include? word }
    end

    def relevance(hash, word)
      # Adds ':relevance' to hash to estimate the value of the result.
      # Matching in 'Name' field is the most expensive.
      hash[:relevance] = 0
      hash[:relevance] += hash['Name'].include?(word) ? 3 : 
                            hash['Type'].include?(word) ? 2 :
                              hash['Designed by'].include?(word) ? 1 : 0
      hash
    end
  end
end
