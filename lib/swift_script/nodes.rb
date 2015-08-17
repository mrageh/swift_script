module SwiftScript
  # Collection of nodes each one representing an expression.
  class Nodes < Struct.new(:nodes)
    def <<(node)
      nodes << node
      self
    end
    # This method is the "interpreter" part of our language. All nodes know how to eval
    # itself and returns the result of its evaluation by implementing the "eval" method.
    # The "context" variable is the environment in which the node is evaluated (local
    # variables, current class, etc.).
    def eval(context)
      return_value = nil
      nodes.each do |node|
        return_value = node.eval(context)
      end
      # The last value evaluated in a method is the return value. Or nil if none.
      return_value || Runtime["nil"]
    end
  end

  # Literals are static values that have a Ruby representation, eg.: a string, a number,
  # true, false, nil, etc.
  class LiteralNode < Struct.new(:value); end

  class NumberNode < LiteralNode
    def eval(context)
      # Here we access the Runtime, which we'll see in the next section, to create a new
      # instance of the Number class.
      Runtime["Number"].new_with_value(value)
    end
  end

  class StringNode < LiteralNode
    def eval(context)
      Runtime["String"].new_with_value(value)
    end
  end

  class TrueNode < LiteralNode
    def initialize
      super(true)
    end

    def eval(context)
      Runtime["true"]
    end
  end

  class FalseNode < LiteralNode
    def initialize
      super(false)
    end

    def eval(context)
      Runtime["false"]
    end
  end

  class NullNode < LiteralNode
    def initialize
      super(nil)
    end

    def eval(context)
      Runtime["nil"]
    end
  end

  # Node of a method call or local variable access, can take any of these forms:
  #
  #   method # this form can also be a local variable
  #   method(argument1, argument2)
  #   receiver.method
  #   receiver.method(argument1, argument2)
  #
  class CallNode < Struct.new(:receiver, :method, :arguments)
    def eval(context)
      # If there's no receiver and the method name is the name of a local variable, then
      # it's a local variable access. This trick allows us to skip the () when calling a
      # method.
      if receiver.nil? && context.locals[method] && arguments.empty?
        context.locals[method]

      # Method call
      else
        if receiver
          value = receiver.eval(context)
        else
          # In case there's no receiver we default to self, calling "print" is like
          # "self.print".
          value = context.current_self
        end

        eval_arguments = arguments.map { |arg| arg.eval(context) }
        value.call(method, eval_arguments)
      end
    end
  end

  # Retrieving the value of a constant.
  class GetConstantNode < Struct.new(:name)
    def eval(context)
      context[name]
    end
  end

  # Setting the value of a constant.
  class SetConstantNode < Struct.new(:name, :value)
    def eval(context)
      context[name] = value.eval(context)
    end
  end

  # Setting the value of a local variable.
  class SetLocalNode < Struct.new(:name, :value)
    def eval(context)
      context.locals[name] = value.eval(context)
    end
  end

  # Method definition.
  class FuncNode < Struct.new(:name, :params, :body)
    def eval(context)
      # Defining a method is adding a method to the current class.
      method = SwiftScriptMethod.new(params, body)
      context.current_class.runtime_methods[name] = method
    end
  end

  # Class definition.
  class ClassNode < Struct.new(:name, :body)
    def eval(context)
      # Try to locate the class. Allows reopening classes to add methods.
      swift_script_class = context[name]

      unless swift_script_class # Class doesn't exist yet
        swift_script_class = SwiftScriptClass.new
        # Register the class as a constant in the runtime.
        context[name] = swift_script_class
      end

      # Evaluate the body of the class in its context. Providing a custom context allows
      # to control where methods are added when defined with the def keyword. In this
      # case, we add them to the newly created class.
      class_context = Context.new(swift_script_class, swift_script_class)

      body.eval(class_context)

      swift_script_class
    end
  end

  # "if" control structure. Look at this node if you want to implement other control
  # structures like while, for, loop, etc.
  class IfNode  < Struct.new(:condition, :body)
    def eval(context)
      # We turn the condition node into a Ruby value to use Ruby's "if" control
      # structure.
      if condition.eval(context).ruby_value
        body.eval(context)
      end
    end
  end

  class WhileNode  < Struct.new(:condition, :body)
    def eval(context)
      # We turn the while node into a Ruby value to use Ruby's "while" control
      # structure.
      while condition.eval(context).ruby_value
        body.eval(context)
      end
    end
  end
end
