module SwiftScript
  class Interpreter
    def initialize
      @parser = Parser.new
    end

    def eval(code)
      @parser.parse(code).eval(Runtime)
    end
  end
end
