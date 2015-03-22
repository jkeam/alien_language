class Node
  attr_accessor :value, :parent, :children

  def initialize(value, parent)
    @value = value
    @parent = parent
    @children = []
  end

  def to_s
    s = "{value: #{@value}, children: \n" 
    s += children.map(&:to_s).join(', ')
    s += "}"
    s
  end

  # find node if it exists
  #TODO: god so ugly
  def add_value(value)
    node = get_child value

    # if node doesn't exist
    # add to correct place to cur node
    if node.nil?
      node = Node.new(value, self)
      @children.push node
      @children.sort!  { |a,b| a.value <=> b.value }
    end
    node
  end

  #TODO: do this smarter, bin search
  def get_child(value) 
    match = @children.find do |i|
      i.value == value
    end
    match
  end
end
