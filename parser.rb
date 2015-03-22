require './forest'

class Parser
  def self.parse(filename='input.txt')
    word_length = 0
    dictionary_length = 0
    test_case_length = 0

    test_cases = []
    forest = Forest.new
    File.new(filename).each_line.with_index do |line, i|
      if i == 0
        word_length, dictionary_length, test_case_length = line.split(' ')
      elsif i >= 1 && i <= dictionary_length.to_i
        build_forest(line.chomp, forest)
      else
        test_cases << build_test_case(line.chomp)
      end
    end
    {
      forest: forest,
      test_cases: test_cases 
    }
  end

  def self.build_forest(d, forest)
    cur = nil
    d.split('').each_with_index do |char, i|
      if i == 0 
        tree = forest.get_tree char

        # lazy init tree 
        if tree.nil?
          cur = Node.new char, nil
          forest.add_tree(char, Tree.new(cur))
        else
          cur = tree.root
        end
      else
        # logic to figure out where to insert
        cur = cur.add_value char
      end
    end
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
