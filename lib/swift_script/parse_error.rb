module SwiftScript

  #Racc can help with syntax errors and identify the line that caused the problem
  class ParseError < Racc::ParseError

    TOKEN_MAP = {
      'INDENT' => 'indent',
      'DEDENT' => 'dedent',
      "\n"     => 'newline'
    }

    def initialize(token_id, value, stack=nil, message=nil)
      @token_id, @value, @stack, @message = token_id, value, stack, message
    end

    def message
      "line #{line} syntax error, #{value_segment}#{token_segment}"
    end

    alias_method :inspect, :message

    private

    def line
      return @value.line if @value.respond_to?(:line)
      'END'
    end

    def token_segment
      msg = " unexpected #{@token_id.to_s.downcase}"
      return msg if @token_id != @value.to_s
      ''
    end

    def value_segment
      @message || "for #{TOKEN_MAP[@value.to_s] || "'#{@value}'"}"
    end
  end
end
