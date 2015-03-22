require './parser'
require './tree'
require 'log4r'
include Log4r

class String
  def initial
    self[0,1]
  end
end

class Alien
  attr_accessor :root_to_tree, :log
  def initialize(log)
    @log = log
    @root_to_tree = {}
  end

  def build_dict(dict)
    dict.each do |d|
      cur = nil
      d.split('').each_with_index do |l, i|
        if i == 0 
          first_char = l
          tree = @root_to_tree[first_char]

          # lazy init tree 
          if tree.nil?
            cur = Node.new first_char, nil
            tree = Tree.new cur
            @root_to_tree[first_char] = tree
          else
            cur = tree.root
          end
        else
          # logic to figure out where to insert
          cur = cur.add_value l
        end
      end
    end
  end

  def dump
    @root_to_tree.keys.each do |r|
      puts "#{r}: #{@root_to_tree[r]}"
    end
  end

  def count_matches(test_cases)
    answer = []
    test_cases.each_with_index do |tc, i|
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
        log.debug "inputs during building: #{inputs}, i: #{i}"
      end

      #build strings and check
      log.debug 'new answer'
      answer << check(String.new, 0, inputs)
    end
    answer
  end

  # returns the number of matches
  def check(prefix, i, inputs)
    while i < inputs.size
      log.debug "inputs.size: #{inputs.size}"
      cur = inputs[i]

      if (cur.kind_of?(Array))
        matches = 0
        popped_off = []
        while (!cur.empty?)
          value = cur.pop   
          popped_off << value
          cur_prefix = prefix + value
          # temporarily move forward to check the rest
          log.debug "cur_prefix: #{cur_prefix}, i: #{i + 1}"
          matches += check(cur_prefix, i+1, inputs)
          log.debug "prefix after check: #{prefix}"
        end
        inputs[i] = popped_off
        return matches
      else
        prefix += cur
        i += 1
        log.debug "prefix after cur: #{prefix}, i: #{i}"
      end
    end

    # at end, time to test
    # if it matches, return 1, else 0
    match = test_match(prefix) 
    log.debug "#{match} for #{prefix}"
    match
  end

  def test_match(word)
    tree = @root_to_tree[word.initial]
    return 0 if tree.nil?
    tree.match(word) ? 1 : 0
  end

end


#setup logger
log = Logger.new 'alienlogger'
log.outputters = Outputter.stdout
log.level = Log4r::INFO

input = Parser.parse 'A-large-practice.txt'
alien = Alien.new log
alien.build_dict input[:dict]
alien.count_matches(input[:test_cases]).each_with_index do |a, i|
  puts "Case ##{i+1}: #{a}"
end
