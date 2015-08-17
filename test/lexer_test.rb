require 'test_helper'

module SwiftScript
  class LexerTest < Minitest::Test
    def setup
      @lexer = Lexer.new
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
      assert_equal [[:WHILE, 'while']], @lexer.tokenize('while')
    end

    def test_indent
    code = <<-CODE
if 1:
  if 2:
    print "..."
    if false:
      pass
    print "done!"
  2

print "The End"
    CODE

      tokens = [
        [:IF, "if"], [:NUMBER, 1],
          [:INDENT, 2],
            [:IF, "if"], [:NUMBER, 2],
            [:INDENT, 4],
              [:IDENTIFIER, "print"], [:STRING, "..."], [:NEWLINE, "\n"],
              [:IF, "if"], [:FALSE, "false"],
              [:INDENT, 6],
                [:IDENTIFIER, "pass"],
             [:DEDENT, 4], [:NEWLINE, "\n"],
             [:IDENTIFIER, "print"], [:STRING, "done!"],
           [:DEDENT, 2], [:NEWLINE, "\n"],
           [:NUMBER, 2],
         [:DEDENT, 0], [:NEWLINE, "\n"],
         [:NEWLINE, "\n"],
         [:IDENTIFIER, "print"], [:STRING, "The End"]
      ]

      assert_equal tokens, @lexer.tokenize(code)
    end
  end

end
