module SwiftScript
  #Represents an SwiftScript instance in the Ruby World
  class SwiftScriptObject
    attr_accessor :runtime_class, :ruby_value

    #Each object has a class (named runtime_class to prevent errors with Ruby's class method).
    #Optionally an object can hold a Ruby value (e.g.:numbers and strings).
    def initialize(runtime_class, ruby_value=self)
      @runtime_class = runtime_class
      @ruby_value    = ruby_value
    end

    #Call a method on the object.
    def call(method, args=[])
      #Like a typical Class-based runtime model, we store methods in the class of the object
      @runtime_class.lookup(method).call(self, args)
    end
  end
end
