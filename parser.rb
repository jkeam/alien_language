class Parser
  def self.parse(filename='input.txt')
    word_length = 0
    dictionary_length = 0
    test_case_length = 0

    test_cases = []
    dict = []
    File.new(filename).each_line.with_index do |line, i|
      if i == 0
        word_length, dictionary_length, test_case_length = line.split(' ')
      elsif i >= 1 && i <= dictionary_length.to_i
        dict << line.chomp
      else
        test_cases << line.chomp
      end
    end
    {
      dict: dict, 
      test_cases: test_cases 
    }
  end
end
