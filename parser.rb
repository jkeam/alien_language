require './trie'

class Parser
  def self.parse(filename='input/input.txt')
    word_length = 0
    dictionary_length = 0
    test_case_length = 0

    test_cases = []
    trie = Trie.new
    File.new(filename).each_line.with_index do |line, i|
      if i == 0
        word_length, dictionary_length, test_case_length = line.split(' ')
      elsif i >= 1 && i <= dictionary_length.to_i
        trie.add line.chomp
      else
        test_cases << build_test_case(line.chomp)
      end
    end
    {
      trie: trie,
      test_cases: test_cases 
    }
  end

  def self.build_test_case(tc)
    inputs = []
    capture = false
    queue = nil
    tc.split('').each do |l|
      if l == ')'
        inputs << queue
        queue = nil
      elsif !queue.nil?
        queue.push l
      elsif l == '('
        capture = true
        queue = []
      else
        inputs << l
      end
    end
    inputs
  end
end
