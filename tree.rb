require './node'

class Tree
  attr_accessor :root

  def initialize(root)
    @root = root
  end

  def to_s
    "root: #{@root}"
  end
end
