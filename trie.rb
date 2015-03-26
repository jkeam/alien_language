class Trie

  def initialize
    @root = TrieNode.new nil, nil
  end

  # add word and returns the root node containing that word
  def add(word)
    return if word.nil? || word.gsub(/\s+/, '') == ''
    letters = word.split('')
    subroot = get_root letters[0], {create: true, sym: letters[0].to_sym} 
    add_letters_to_root letters, subroot 
    subroot 
  end

  # get the root and optionally create a new root if not found
  def get_root(value, options={})
    subroot = @root.get_child value
    if options[:create] && subroot.nil?
      sym = options[:sym]
      subroot = TrieNode.new sym, nil
      @root.children[sym] = subroot 
    end
    subroot
  end

  # node for the trie
  class TrieNode
    attr_accessor :value, :parent, :children

    def initialize(value, parent)
      @value = value
      @parent = parent
      @children = {}
    end

    def to_s
      s = "{\n"
      s += "value: #{@value}, children: \n" 
      s += children.inspect
      s += "\n}"
      s
    end

    # find node if it exists and add value to it
    def add(value)
      node = get_child value

      # if node doesn't exist
      # add to correct place to cur node
      if node.nil?
        node = TrieNode.new(value, self)
        @children[value.to_sym] = node
      end
      node
    end

    def get_child(value) 
      @children[value.to_sym]
    end
  end


  private 
    # does the work of adding the letters to the created root
    def add_letters_to_root(letters, subroot)
      cur = subroot 
      letters.shift
      letters.each { |l| cur = cur.add(l) }
    end
end

