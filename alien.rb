require './parser'
require './tree'
require './forest'
require 'log4r'

class Alien
  include Log4r
  attr_accessor :forest, :log
  def initialize(forest)
    log = Logger.new 'alien_logger'
    log.outputters = Outputter.stdout
    log.level = Log4r::ERROR
    @log = log

    @forest = forest
  end

  def count_matches(test_cases)
    answer = []
    log.info "Total test cases: #{test_cases.size}"
    test_cases.each_with_index do |inputs, i|

      t1 = Time.now
      answer << dfs('', 0, inputs)

      t2 = Time.now
      delta = t2 - t1
      log.info "Processing test case: #{i} in #{delta*1000}ms"
    end
    answer
  end

  # Depth first search, returning the number of matches
  def dfs(prefix, i, inputs, node=nil)
    while i < inputs.size
      cur = inputs[i]

      if cur.kind_of?(Array)
        matches = 0
        popped_off = []
        current_node = node

        # dfs for every potential element
        while (!cur.empty?)
          value = cur.pop   
          popped_off << value
          node = (i == 0) ? @forest.get_tree_root(value) : current_node.get_child(value)
          matches += dfs(prefix + value, i+1, inputs, node) if node
        end

        # restore elements popped off from dfs
        inputs[i] = popped_off
        return matches
      else
        # move forward for sure elements
        node = (i == 0) ? @forest.get_tree_root(cur) : node.get_child(cur)
        prefix += cur
        i += 1

        #if next node doesn't exist, means no letter matches
        return 0 if node.nil?
      end
    end
    # at the end, see if we have a matching node for the entire string
    node.nil? ? 0 : 1
  end
end

input = Parser.parse 'input/A-large-practice.txt'
# input = Parser.parse 'input/A-small-practice.txt'
alien = Alien.new input[:forest]
alien.count_matches(input[:test_cases]).each_with_index { |a, i| puts "Case ##{i+1}: #{a}" }
