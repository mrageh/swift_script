module SwiftScript
  class SwiftScriptClass < SwiftScriptObject
    attr_reader :runtime_methods, :runtime_superclass

    def initialize(superclass = nil)
      @runtime_methods = {}
      @runtime_superclass = superclass

      if defined?(Runtime)
        runtime_class = Runtime["Class"]
      else
        runtime_class = nil
      end

      super(runtime_class)
    end

    def lookup(method_name)
      method = @runtime_methods[method_name]
      unless method
        if @runtime_superclass
          return @runtime_superclass.lookup(method_name)
        else
          raise "Method not found: #{method_name}"
        end
      end
      method
    end

    def new
      SwiftScriptObject.new(self)
    end

    def new_with_value(value)
      SwiftScriptObject.new(self, value)
    end
  end
end
