using TreeDataStructures
using AbstractTrees
using Test

@testset "TreeDataStructures.jl" begin
  @testset "AVLTree" begin
    tree = AVLTree{Int,Int}()
    tree[2] = 20
    tree[1] = 10
    tree[3] = 30
    @test tree[2] == 20
    @test tree[1] == 10
    @test tree[3] == 30

    # value conversion
    tree = AVLTree{Int,Float64}()
    tree[2] = 20
    tree[1] = 10
    tree[3] = 30
    @test tree[2] isa Float64
    @test tree[2] == 20.0
    @test tree[1] isa Float64
    @test tree[1] == 10.0
    @test tree[3] isa Float64
    @test tree[3] == 30.0

    # tree that accept any types
    tree = AVLTree()
    tree[2] = 'A'
    tree[1] = 1.1
    tree[3] = "test"
    @test tree[2] == 'A'
    @test tree[1] == 1.1
    @test tree[3] == "test"

    # AbstractTrees interface
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[2] = 20
    tree[4] = 40
    tree[1] = 10
    tree[5] = 50
    root = tree.root
    @test children(root) === (root.left, root.right)
    @test children(root.left) === (root.left.left,)
    @test children(root.right) === (root.right.right,)
    @test children(root.left.left) === ()
    @test children(root.right.right) === ()
    @test nodevalue(root) == 30
    @test nodevalue(root.left) == 20
    @test nodevalue(root.right) == 40
    @test nodevalue(root.left.left) == 10
    @test nodevalue(root.right.right) == 50
    @test NodeType(root) === HasNodeType()
    @test nodetype(root) === typeof(root)

    # left rotate
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[2] = 20
    tree[3] = 30
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # right rotate
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[2] = 20
    tree[1] = 10
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # left-right rotate
    tree = AVLTree{Int,Int}()
    tree[3] = 30
    tree[1] = 10
    tree[2] = 20
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # right-left rotate
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[3] = 30
    tree[2] = 20
    @test tree.root.key == 2
    @test tree.root.left.key == 1
    @test tree.root.right.key == 3

    # show
    tree = AVLTree{Int,Int}()
    @test sprint(show, MIME("text/plain"), tree) == "AVLTree()"
    tree[3] = 30
    tree[2] = 20
    tree[4] = 40
    tree[1] = 10
    tree[5] = 50
    @test sprint(show, MIME("text/plain"), tree) == """
    AVLTree
    3 => 30
    ├─ 2 => 20
    │  └─ 1 => 10
    └─ 4 => 40
       └─ 5 => 50"""
  end
end
