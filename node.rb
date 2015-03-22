class Node
  attr_accessor :value, :parent, :children

  def initialize(value, parent)
    @value = value
    @parent = parent
    @children = {}
  end

  def to_s
    s = "{value: #{@value}, children: \n" 
    s += children.inspect
    s += "}"
    s
  end

  # find node if it exists
  def add_value(value)
    node = get_child value

    # if node doesn't exist
    # add to correct place to cur node
    if node.nil?
      node = Node.new(value, self)
      @children[value] = node
    end
    node
  end

  def get_child(value) 
    @children[value]
  end
end
