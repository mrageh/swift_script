module SwiftScript
  class BlockLexer
    KEYWORDS = ["func", "class", "if", "true", "false", "null", "while"]

    def tokenize(code)
      # Cleanup code by remove extra line breaks
      code.chomp!

      # Current character position we're parsing
      i = 0

      # Collection of all parsed tokens in the form [:TOKEN_TYPE, value]
      tokens = []

      # This is how to implement a very simple scanner.
      # Scan one character at the time until you find something to parse.
      while i < code.size
        chunk = code[i..-1]

        # Matching standard tokens.
        #
        # Matching if, print, method names, etc.
        if identifier = chunk[/\A([a-z]\w*)/, 1]
          # Keywords are special identifiers tagged with their own name, 'if' will result
          # in an [:IF, "if"] token
          if KEYWORDS.include?(identifier)
            tokens << [identifier.upcase.to_sym, identifier]
          # Non-keyword identifiers include method and variable names.
          else
            tokens << [:IDENTIFIER, identifier]
          end
          # skip what we just parsed
          i += identifier.size

        # Matching class names and constants starting with a capital letter.
        elsif constant = chunk[/\A([A-Z]\w*)/, 1]
          tokens << [:CONSTANT, constant]
          i += constant.size

        elsif number = chunk[/\A([0-9]+)/, 1]
          tokens << [:NUMBER, number.to_i]
          i += number.size

        elsif string = chunk[/\A"(.*?)"/, 1]
          tokens << [:STRING, string]
          i += string.size + 2

        # Match long operators such as ||, &&, ==, !=, <= and >=.
        # One character long operators are matched by the catch all `else` at the bottom.
        elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
          tokens << [operator, operator]
          i += operator.size

        # Ignore whitespace
        elsif chunk.match(/\A /)
          i += 1

        # Catch new lines
        elsif new_line = chunk[/\A(\n)/m, 1] # Matches ": <newline> <spaces>"
          tokens << [:NEWLINE, new_line]
          i += new_line.size

        # Catch all identation
        elsif open = chunk[/\A(\{)/, 1] # Matches ": <newline> <spaces>"
          tokens << [:OPEN, open]
          i += open.size
        elsif close = chunk[/\A(\})/, 1]
          tokens << [:CLOSE, close]
          i += close.size
        # Catch all single characters
        # We treat all other single characters as a token. Eg.: ( ) , . ! + - <
        else
          value = chunk[0,1]
          tokens << [value, value]
          i += 1

        end
      end

      tokens
    end
  end
end
