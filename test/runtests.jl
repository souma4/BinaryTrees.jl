using TreeDataStructures
using Test

@testset "TreeDataStructures.jl" begin
  @testset "AVLTree" begin
    tree = AVLTree{Int,Int}()
    tree[1] = 10
    tree[2] = 20
    tree[3] = 30
    @test tree[1] == 10
    @test tree[2] == 20
    @test tree[3] == 30

    # value conversion
    tree = AVLTree{Int,Float64}()
    tree[1] = 10
    tree[2] = 20
    tree[3] = 30
    @test tree[1] isa Float64
    @test tree[1] == 10.0
    @test tree[2] isa Float64
    @test tree[2] == 20.0
    @test tree[3] isa Float64
    @test tree[3] == 30.0

    # tree that accept any types
    tree = AVLTree()
    tree[1] = 1.1
    tree[2] = 'A'
    tree[3] = "test"
    @test tree[1] == 1.1
    @test tree[2] == 'A'
    @test tree[3] == "test"

    # show
    tree = AVLTree{Int,Int}()
    @test sprint(show, MIME("text/plain"), tree) == "AVLTree()"
    tree[1] = 10
    tree[2] = 20
    tree[3] = 30
    @test sprint(show, MIME("text/plain"), tree) == """
    AVLTree
    2 => 20
    ├─ 1 => 10
    └─ 3 => 30"""
  end
end
