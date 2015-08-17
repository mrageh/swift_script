require_relative 'object'
require_relative 'class'
require_relative 'method'
require_relative 'context'

module SwiftScript
  #Bootstrap the runtime. This is where we assemble all the classes and objects together, to form the runtime.
  #What's happening in the runtime:
  swift_script_class               = SwiftScriptClass.new # Class
  swift_script_class.runtime_class = swift_script_class   # Class.class = Class
  object_class                     = SwiftScriptClass.new # Object = Class.new
  object_class.runtime_class       = swift_script_class   # Object.class = Class

  #Create the Runtime object (the root context) on which all code will start it's evaluation
  Runtime           = Context.new(object_class.new)
  Runtime["Class"]  = swift_script_class
  Runtime["Object"] = object_class
  Runtime["Number"] = SwiftScriptClass.new(Runtime["Object"])
  Runtime["String"] = SwiftScriptClass.new(Runtime["Object"])

  #Everything is an object in our language, even true, false and nil.
  #So they need to have a class too.
  Runtime["TrueClass"]  = SwiftScriptClass.new(Runtime["Object"])
  Runtime["FalseClass"] = SwiftScriptClass.new(Runtime["Object"])
  Runtime["NilClass"]   = SwiftScriptClass.new(Runtime["Object"])
  Runtime["true"]       = Runtime["TrueClass"].new_with_value(true)
  Runtime["false"]      = Runtime["FalseClass"].new_with_value(false)
  Runtime["nil"]        = Runtime["NilClass"].new_with_value(nil)

  #Add a few core methods to the runtime.
  #Add the `new` method to classes, used to instantiate a class:
  #e.g: Object.new, Number.new, String.new, etc
  Runtime["Class"].runtime_methods["new"] = proc do |receiver, args|
    receiver.new
  end

  #Print an object to the console.
  #eg: print("hi there am Adam's Runtime!")
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

  #Mimic Object.new in the language
  object = Runtime["Object"].call("new")
end
