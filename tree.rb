require './node'

class Tree
  attr_accessor :root

  def initialize(root)
    @root = root
  end

  def to_s
    "root: #{@root}"
  end

  def match(word)
    cur = root
    word.split('').each_with_index do |w, i|
      if i > 0
        cur = cur.get_child w
        return false if cur.nil? 
      end
    end
    !cur.nil?
  end

end
