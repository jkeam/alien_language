class Node
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
  def add_value(value)
    node = get_child value

    # if node doesn't exist
    # add to correct place to cur node
    if node.nil?
      node = Node.new(value, self)
      @children[value.to_sym] = node
    end
    node
  end

  def get_child(value) 
    @children[value.to_sym]
  end
end
