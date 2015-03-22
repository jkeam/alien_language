class Forest
  def initialize
    @root_to_tree = {}
  end

  def add_tree(value, tree)
    @root_to_tree[value.to_sym] = tree
  end

  def get_tree(value)
    @root_to_tree[value.to_sym]
  end

  def get_tree_root(value)
    @root_to_tree[value.to_sym] ? @root_to_tree[value.to_sym].root : nil
  end
end
