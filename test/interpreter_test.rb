require 'test_helper'

module SwiftScript
  class InterpreterTest < Minitest::Test
    def setup
      @interpreter = Interpreter.new
    end

    def test_number
      assert_equal 1, @interpreter.eval('1').ruby_value
    end

    def test_assign
      assert_equal true, @interpreter.eval('true').ruby_value
    end

    def test_method
      code = <<-CODE
func boo(a):
  a

boo("yah!")
CODE
      assert_equal "yah!", @interpreter.eval(code).ruby_value
    end

    def test_reopen_class
      code = <<-CODE
class Number:
  func ten:
    10
1.ten
CODE
      assert_equal 10, @interpreter.eval(code).ruby_value
    end

    def test_define_class
      code = <<-CODE
class Pony:
  func foo:
    true

Pony.new.foo
CODE
      assert_equal true, @interpreter.eval(code).ruby_value
    end

    def test_if
      code = <<-CODE
if true:
  "works!"
CODE
      assert_equal "works!", @interpreter.eval(code).ruby_value
    end

    def  test_interpreter
      code = <<-CODE
class SwiftScript:
  func does_it_work:
    "yeah!"

swift_script_object = SwiftScript.new
if swift_script_object:
  print(swift_script_object.does_it_work)
CODE

      assert_output(/yeah!\n/) { @interpreter.eval(code) }
    end

    def test_while
      code = <<-CODE
a = 1
while a < 2:
  a = a + 1
  print("works!")

print("the loop has been exited")
CODE
      assert_output(/the loop has been exited\n/) { @interpreter.eval(code).ruby_value }
    end
  end
end
