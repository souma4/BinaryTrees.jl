# ------------
# BINARY NODE
# ------------

"""
    BinaryNode

Binary tree node with key and optional value, left and right children.
"""
abstract type BinaryNode end

"""
    BinaryTrees.key(node)

Key of the `node`.
"""
key(node::BinaryNode) = node.key

"""
    BinaryTrees.value(node)

Value of the `node`, if it does not exist, `nothing` is returned.
"""
value(node::BinaryNode) = node.value

"""
    BinaryTrees.left(node)

Left child of the `node`, if it does not exist, `nothing` is returned.
"""
left(node::BinaryNode) = node.left

"""
    BinaryTrees.right(node)

Right child of the `node`, if it does not exist, `nothing` is returned.
"""
right(node::BinaryNode) = node.right

# ------------
# BINARY TREE
# ------------

"""
    BinaryTree

Binary Tree with a root node.
"""
abstract type BinaryTree end

"""
    BinaryTrees.root(tree)

Root node of the `tree`.
"""
root(tree::BinaryTree) = tree.root

"""
    BinaryTrees.search(tree, key)

Search the `tree` for the node that has `key`.
If the tree does not have a node with `key`, `nothing` is returned.
"""
function search end

"""
    BinaryTrees.insert!(tree, key, value)

Insert a node into the `tree` with `key` and `value`.
If a node with `key` already exists, the value
of the node will be updated.

    BinaryTrees.insert!(tree, key)

Insert a node into the `tree` with `key` and no value.
"""
function insert! end

"""
    BinaryTrees.delete!(tree, key)

Delete the node that has `key` from the `tree`.
"""
function delete! end

# -----------
# IO METHODS
# -----------

function Base.show(io::IO, node::BinaryNode)
  name = nameof(typeof(node))
  print(io, "$name(")
  _printkeyvalue(io, node)
  print(io, ")")
end

function Base.show(io::IO, tree::BinaryTree)
  name = nameof(typeof(tree))
  if isnothing(tree.root)
    print(io, "$name()")
  else
    println(io, "$name")
    str = AbstractTrees.repr_tree(tree.root, context=io)
    print(io, rstrip(str)) # remove \n at end
  end
end

# --------------
# ABSTRACTTREES
# --------------

function AbstractTrees.children(node::BinaryNode)
  leftnode = left(node)
  rightnode = right(node)
  if !isnothing(leftnode) && !isnothing(rightnode)
    (leftnode, rightnode)
  elseif !isnothing(leftnode)
    (leftnode,)
  elseif !isnothing(rightnode)
    (rightnode,)
  else
    ()
  end
end

AbstractTrees.NodeType(::Type{<:BinaryNode}) = AbstractTrees.HasNodeType()
AbstractTrees.nodetype(T::Type{<:BinaryNode}) = T

AbstractTrees.printnode(io::IO, node::BinaryNode) = _printkeyvalue(io, node)

# -----------------
# HELPER FUNCTIONS
# -----------------

function _printkeyvalue(io::IO, node::BinaryNode)
  ioctx = IOContext(io, :compact => true, :limit => true)
  val = value(node)
  if isnothing(val)
    show(ioctx, key(node))
  else
    show(ioctx, key(node))
    print(ioctx, " => ")
    show(ioctx, val)
  end
end

# -----------
#  UTILITIES
# -----------

minnode(tree::BinaryTree) = minnode(root(tree))

function minnode(node::BinaryNode)
  leftnode = left(node)
  isnothing(leftnode) ? node : minnode(leftnode)
end

minnode(node::Nothing) = nothing

maxnode(tree::BinaryTree) = maxnode(root(tree))

function maxnode(node::BinaryNode)
  rightnode = right(node)
  isnothing(rightnode) ? node : maxnode(rightnode)
end

maxnode(node::Nothing) = nothing

function abovebelow(tree::BinaryNode, x::BinaryNode)
  above, below = nothing, nothing
  current = tree
  # Traverse from the root to the target node, updating candidates.
  while !isnothing(current) && key(current) != key(x)
    if key(x) < key(current)
      # current is a potential above (successor)
      above = current
      current = left(current)
    else # x.key > current.key
      # current is a potential below (predecessor)
      below = current
      current = right(current)
    end
  end

  # If the node wasn't found, return the best candidate values
  if isnothing(current)
    return (above, below)
  end

  # Found the node with key equal to x.key.
  # Now, if there is a left subtree, the true below (predecessor) is the maximum in that subtree.
  if !isnothing(left(current))
    below = maxnode(left(current))
  end
  # Similarly, if there is a right subtree, the true above (successor) is the minimum in that subtree.
  if !isnothing(right(current))
    above = minnode(right(current))
  end

  (above, below)
end

function abovebelow(tree::BinaryTree, x::BinaryNode)
  abovebelow(root(tree), x)
end

function abovebelow(tree, x::Nothing)
  (nothing, nothing)
end
