require 'test_helper'

module SwiftScript
  class ParserTest < Minitest::Test
    def setup
      @parser =  Parser.new
    end

    def test_number
      assert_equal Nodes.new([NumberNode.new(1)]), @parser.parse("1")
    end

    def test_expression
      assert_equal Nodes.new([NumberNode.new(1), StringNode.new("hi")]), @parser.parse(%{1\n"hi"})
    end

    def test_call
      assert_equal Nodes.new([CallNode.new(NumberNode.new(1), "method", [])]), @parser.parse("1.method")
    end

    def test_call_with_args
      assert_equal Nodes.new([SetLocalNode.new("a", NumberNode.new(1))]), @parser.parse("a = 1")
      assert_equal Nodes.new([SetConstantNode.new("A", NumberNode.new(1))]), @parser.parse("A = 1")
    end

    def test_func
      code = <<-CODE
func method:
  true
      CODE
      nodes = Nodes.new([
        FuncNode.new("method", [], Nodes.new([TrueNode.new]))
      ])

      assert_equal nodes, @parser.parse(code)
    end

    def test_def_with_param
      code = <<-CODE
func method(a, b):
  true
      CODE

      nodes = Nodes.new([
        FuncNode.new("method", ["a", "b"], Nodes.new([TrueNode.new]))
      ])

      assert_equal nodes, @parser.parse(code)
    end

    def test_class
      code = <<-CODE
  class Muffin:
    true
      CODE

      nodes = Nodes.new([
        ClassNode.new("Muffin", Nodes.new([TrueNode.new]))
      ])

      assert_equal nodes, @parser.parse(code)
    end

    def test_aritmetic
      nodes = Nodes.new([
        CallNode.new(NumberNode.new(1), "+", [
          CallNode.new(NumberNode.new(2), "*", [NumberNode.new(3)])
        ])
      ])

      assert_equal nodes, @parser.parse("1 + 2 * 3")
      assert_equal nodes, @parser.parse("1 + (2 * 3)")
    end

    def test_binary_operator
      assert_equal Nodes.new([
        CallNode.new(
          CallNode.new(NumberNode.new(1), "+", [NumberNode.new(2)]),
          "||", [NumberNode.new(3)]
        )
      ]), @parser.parse("1 + 2 || 3")
    end

    def test_unary_operator
      assert_equal Nodes.new([
        CallNode.new(NumberNode.new(2), "!", [])
      ]), @parser.parse("!2")
    end

    def test_if
      code = <<-CODE
  if true:
    null
      CODE

      nodes = Nodes.new([
        IfNode.new(TrueNode.new, Nodes.new([NullNode.new]))
      ])

      assert_equal nodes, @parser.parse(code)
    end

    def test_while
      code = <<-CODE
  while true:
    null
      CODE

      nodes = Nodes.new([
        WhileNode.new(TrueNode.new, Nodes.new([NullNode.new]))
      ])

      assert_equal nodes, @parser.parse(code)
    end
  end
end
