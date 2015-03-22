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
    t1 = Time.now

    log.info 'start building dictionary'
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
    log.info 'done building dictionary'
    t2 = Time.now
    delta = t2 - t1
    log.debug "Timing build_dict: #{delta}"
  end

  def build_test_case(tc)
    t1 = Time.now

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
      log.debug "inputs during building: #{inputs}"
    end
    t2 = Time.now
    delta = t2 - t1
    log.debug "Timing build_test_case: #{delta}"

    inputs
  end

  def count_matches(test_cases)

    answer = []
    log.info "total test cases: #{test_cases.size}"
    test_cases.each_with_index do |tc, i|

      log.info "processing test case: #{i}"
      inputs = build_test_case tc

      log.debug 'new answer'
      t1 = Time.now
      answer << check('', 0, inputs)

      t2 = Time.now
      delta = t2 - t1
      log.debug "Timing count_matches: #{delta}"
    end
    answer
  end

  # returns the number of matches
  def check(prefix, i, inputs, node=nil)
    while i < inputs.size
      log.debug "inputs.size: #{inputs.size}"
      cur = inputs[i]

      if cur.kind_of?(Array)
        j = i + 1
        matches = 0
        popped_off = []
        current_node = node
        while (!cur.empty?)
          value = cur.pop   
          popped_off << value
          cur_prefix = prefix + value

          if (i == 0) 
            node = (@root_to_tree[value]) ? @root_to_tree[value].root : nil
          else
            log.debug "i: #{i} and prefix: #{prefix} and node.nil?: #{node.nil?}"
            node = current_node.get_child value
          end

          # temporarily move forward to check the rest
          log.debug "cur_prefix: #{cur_prefix}, j: #{j}, node.nil?: #{node.nil?}"
          matches += check(cur_prefix, j, inputs, node) if node
          log.debug "prefix after check: #{prefix}"
        end
        inputs[i] = popped_off
        return matches
      else
        if (i == 0) 
          node = (@root_to_tree[cur]) ? @root_to_tree[cur].root : nil
        else
          node = node.get_child cur
        end

        prefix += cur
        i += 1

        if node.nil?
          log.debug "ending early b/c prefix doesn't match in else.  stopping on i: #{i} and prefix: #{prefix}"
          return 0
        else
          log.debug "prefix after cur: #{prefix}, i: #{i}"
        end
      end
    end
    # at the end, test it now
    node.nil? ? 0 : 1
  end
end


#setup logger
log = Logger.new 'alienlogger'
log.outputters = Outputter.stdout
log.level = Log4r::DEBUG

# input = Parser.parse 'A-large-practice.txt'
input = Parser.parse 
alien = Alien.new log
alien.build_dict input[:dict]
alien.count_matches(input[:test_cases]).each_with_index do |a, i|
  puts "Case ##{i+1}: #{a}"
end
