module SwiftScript
  # Represents a SwiftScript class in the Ruby world. Classes are objects in SwiftScript.
  # So they inherit from SwiftScriptObject

  class SwiftScriptClass < SwiftScriptObject
    attr_reader :runtime_methods, :runtime_superclass

    # Creates a new class. Number is an instance of Class for example
    def initialize(superclass = nil)
      @runtime_methods = {}
      @runtime_superclass = superclass

      # Check if we're bootstraping (launching the runtime). During this process
      # the runtime is not fully initialized and core classes do not yet exist, so
      # we defer using those once the language is bootstrapped.
      # This solves the chicken-and-the-egg problem with the Class class.
      # We can initialize Class then set Class.class = Class.
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

    #Creates a new instance of this class
    def new
      SwiftScriptObject.new(self)
    end

    #Create an instance of this SwiftScript class that holds a Ruby value.
    #Like a String, Number or True.
    def new_with_value(value)
      SwiftScriptObject.new(self, value)
    end
  end
end
