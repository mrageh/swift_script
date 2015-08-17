module SwiftScript
  class SwiftScriptMethod
    def initialize(params, body)
      @params = params
      @body   = body
    end

    def call(receiver, args)
      # Create a context of evaluation in which the method will execute.
      context = Context.new(receiver)

      # Assign args to local vars
      @params.each_with_index do |params, index|
        context.locals[params] = args[index]
      end

      @body.eval(context)
    end
  end
end
