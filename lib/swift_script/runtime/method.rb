module SwiftScript
  class SwiftScriptMethod
    def initialize(params, body)
      @params = params
      @body   = body
    end

    def call(receiver, args)
      context = Context.new(receiver)

      @params.each_with_index do |params, index|
        context.locals[params] = args[index]
      end

      @body.eval(context)
    end
  end
end
