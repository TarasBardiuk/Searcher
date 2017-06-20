class FilterService
  class << self
    def data(query)
      # Read and parse JSON-file, and transform all hash values to uppercase
      data = value_upcase(JSON.parse(File.read('data.json')))
      if query
        # If search query exists, we split it using regex, which also handles
        # input with double quotes
        query_array = query.upcase.split(/\s+(?=(?:[^"]*"[^"]*")*[^"]*$)/)
        query_array.each do |search_word|
          search_word = search_word[1..-2] if search_word.include?('"')
          data = matcher(data, search_word)
        end
      end
      data
    end

    private

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

    def value_upcase(data_array)
      # Uses for case-insensitive search.
      data_array.each do |hash|
        hash.each { |k, v| v.upcase! }
      end
    end
  end
end