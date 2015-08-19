require_relative 'object'
require_relative 'class'
require_relative 'method'
require_relative 'context'

module SwiftScript
  swift_script_class               = SwiftScriptClass.new
  swift_script_class.runtime_class = swift_script_class
  object_class                     = SwiftScriptClass.new
  object_class.runtime_class       = swift_script_class

  Runtime           = Context.new(object_class.new)
  Runtime["Class"]  = swift_script_class
  Runtime["Object"] = object_class
  Runtime["Number"] = SwiftScriptClass.new(Runtime["Object"])
  Runtime["String"] = SwiftScriptClass.new(Runtime["Object"])

  Runtime["TrueClass"]  = SwiftScriptClass.new(Runtime["Object"])
  Runtime["FalseClass"] = SwiftScriptClass.new(Runtime["Object"])
  Runtime["NilClass"]   = SwiftScriptClass.new(Runtime["Object"])
  Runtime["true"]       = Runtime["TrueClass"].new_with_value(true)
  Runtime["false"]      = Runtime["FalseClass"].new_with_value(false)
  Runtime["nil"]        = Runtime["NilClass"].new_with_value(nil)

  Runtime["Class"].runtime_methods["new"] = proc do |receiver, args|
    receiver.new
  end

  Runtime["Object"].runtime_methods["print"] = proc do |receiver, args|
    puts args.first.ruby_value
    Runtime["nil"]
  end

  Runtime["Number"].runtime_methods["+"] = proc do |receiver, args|
    result = receiver.ruby_value + args.first.ruby_value
    Runtime["Number"].new_with_value(result)
  end

  Runtime["Number"].runtime_methods["<"] = proc do |receiver, args|
    result = receiver.ruby_value > args.first.ruby_value
    Runtime["Number"].new_with_value(result)
  end

  object = Runtime["Object"].call("new")
end
