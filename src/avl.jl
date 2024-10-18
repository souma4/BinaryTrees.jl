# ---------
# AVL NODE
# ---------

mutable struct AVLNode{K,V}
  key::K
  value::V
  left::Union{AVLNode{K,V},Nothing}
  right::Union{AVLNode{K,V},Nothing}
  height::Int
end

AVLNode(key, value) = AVLNode(key, value, nothing, nothing, 1)

Base.convert(::Type{AVLNode{K,V}}, node::AVLNode) where {K,V} =
  AVLNode{K,V}(node.key, node.value, node.left, node.right, node.height)

function AbstractTrees.children(node::AVLNode)
  if !isnothing(node.left) && !isnothing(node.right)
    (node.left, node.right)
  elseif !isnothing(node.left)
    (node.left,)
  elseif !isnothing(node.right)
    (node.right,)
  else
    ()
  end
end

AbstractTrees.nodevalue(node::AVLNode) = node.value

# ---------
# AVL TREE
# ---------

mutable struct AVLTree{K,V}
  root::Union{AVLNode{K,V},Nothing}
end

AVLTree{K,V}() where {K,V} = AVLTree{K,V}(nothing)
AVLTree() = AVLTree{Any,Any}()

function Base.getindex(tree::AVLTree{K}, key::K) where {K}
  node = _search(tree, key)
  isnothing(node) && throw(KeyError(key))
  node.value
end

function Base.setindex!(tree::AVLTree, value, key)
  tree.root = _insert!(tree.root, key, value)
  tree
end

function Base.delete!(tree::AVLTree{K}, key::K) where {K}
  _delete!(tree.root, key)
  tree
end

function Base.show(io::IO, ::MIME"text/plain", tree::AVLTree)
  if isnothing(tree.root)
    print(io, "AVLTree()")
  else
    println(io, "AVLTree")
    str = AbstractTrees.repr_tree(tree.root, context=io)
    print(io, str[begin:(end - 1)]) # remove \n at end
  end
end

# -----------------
# HELPER FUNCTIONS
# -----------------

function _search(tree, key)
  node = tree.root
  while !isnothing(node) && key ≠ node.key
    node = key < node.key ? node.left : node.right
  end
  node
end

function _insert!(root, key, value)
  if isnothing(root)
    return AVLNode(key, value)
  elseif key < root.key
    root.left = _insert!(root.left, key, value)
  elseif key > root.key
    root.right = _insert!(root.right, key, value)
  else
    root.value = value
    return root
  end

  _updateheight!(root)

  bf = _balancefactor(root)

  if bf > 1 && key < root.left.key
    _rightrotate!(root)
  elseif bf < -1 && key > root.right.key
    _leftrotate!(root)
  elseif bf > 1 && key > root.left.key
    _rightrotate!(root)
  elseif bf < -1 && key < root.right.key
    _leftrotate!(root)
  else
    root
  end
end

function _delete!(root, key)
  if isnothing(root)
    return root
  elseif key < root.key
    root.left = _delete!(root.left, key)
  elseif key > root.key
    root.right = _delete!(root.right, key)
  else
    if isnothing(root.left)
      return root.right
    elseif isnothing(root.right)
      return root.left
    else
      temp = _minnode(root.right)
      root.key = temp.key
      root.value = temp.value
      root.right = _delete!(root.right, temp.key)
    end
  end

  _updateheight!(root)

  bf = _balancefactor(root)

  if bf > 1 && _balancefactor(root.left) ≥ 0
    _rightrotate!(root)
  elseif bf < -1 && _balancefactor(root.right) ≤ 0
    _leftrotate!(root)
  elseif bf > 1 && _balancefactor(root.left) < 0
    root.left = _leftrotate!(root.left)
    _rightrotate!(root)
  elseif bf < -1 && _balancefactor(root.right) > 0
    root.right = _rightrotate!(root.right)
    _leftrotate!(root)
  else
    root
  end
end

function _leftrotate!(node)
  B = node.right
  Y = B.left

  B.left = node
  node.right = Y

  _updateheight!(node)
  _updateheight!(B)

  B
end

function _rightrotate!(node)
  A = node.left
  Y = A.right

  A.right = node
  node.left = Y

  _updateheight!(node)
  _updateheight!(A)

  A
end

function _updateheight!(node)
  node.height = 1 + max(_height(node.left), _height(node.right))
  node
end

_height(::Nothing) = 0
_height(node::AVLNode) = node.height

_balancefactor(::Nothing) = 0
_balancefactor(node::AVLNode) = _height(node.left) - _height(node.right)

_minnode(::Nothing) = nothing
_minnode(node::AVLNode) = isnothing(node.left) ? node : _minnode(node.left)
