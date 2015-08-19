module SwiftScript
  class BlockLexer
    KEYWORDS = ["func", "class", "if", "true", "false", "null", "while"]

    def tokenize(code)
      code.chomp!
      i = 0
      tokens = []

      while i < code.size
        chunk = code[i..-1]
        if identifier = chunk[/\A([a-z]\w*)/, 1]
          if KEYWORDS.include?(identifier)
            tokens << [identifier.upcase.to_sym, identifier]
          else
            tokens << [:IDENTIFIER, identifier]
          end
          i += identifier.size
        elsif constant = chunk[/\A([A-Z]\w*)/, 1]
          tokens << [:CONSTANT, constant]
          i += constant.size
        elsif number = chunk[/\A([0-9]+)/, 1]
          tokens << [:NUMBER, number.to_i]
          i += number.size
        elsif string = chunk[/\A"(.*?)"/, 1]
          tokens << [:STRING, string]
          i += string.size + 2
        elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
          tokens << [operator, operator]
          i += operator.size
        elsif chunk.match(/\A /)
          i += 1
        elsif new_line = chunk[/\A(\n)/m, 1]
          tokens << [:NEWLINE, new_line]
          i += new_line.size
        elsif open = chunk[/\A(\{)/, 1]
          tokens << [:OPEN, open]
          i += open.size
        elsif close = chunk[/\A(\})/, 1]
          tokens << [:CLOSE, close]
          i += close.size
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
