require 'test_helper'

module SwiftScript
  class BlockLexerTest < Minitest::Test
    def setup
      @lexer = BlockLexer.new
    end

    def test_number
      assert_equal [[:NUMBER, 1]], @lexer.tokenize("1")
    end

    def test_string
      assert_equal [[:STRING, "hi"]], @lexer.tokenize('"hi"')
    end

    def test_identifier
      assert_equal [[:IDENTIFIER, "name"]], @lexer.tokenize('name')
    end

    def test_operator
      assert_equal [["+",  "+"]], @lexer.tokenize('+')
      assert_equal [["||",  "||"]], @lexer.tokenize('||')
    end

    def test_while
      assert_equal [[:WHILE,  "while"]], @lexer.tokenize('while')
    end

    def test_block_lexer
    code = <<-CODE
if 1 {
  print "..."
  if false {
    pass
  }
  print "done!"
}
print "The End"
CODE

    tokens = [
      [:IF, "if"], [:NUMBER, 1],
      [:OPEN, "{"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "print"], [:STRING, "..."], [:NEWLINE, "\n"],
        [:IF, "if"], [:FALSE, "false"], [:OPEN, "{"], [:NEWLINE, "\n"],
          [:IDENTIFIER, "pass"], [:NEWLINE, "\n"],
        [:CLOSE, "}"], [:NEWLINE, "\n"],
        [:IDENTIFIER, "print"], [:STRING, "done!"], [:NEWLINE, "\n"],
      [:CLOSE, "}"], [:NEWLINE, "\n"],
      [:IDENTIFIER, "print"], [:STRING, "The End"]
    ]
      assert_equal tokens, @lexer.tokenize(code)
    end
  end
end
