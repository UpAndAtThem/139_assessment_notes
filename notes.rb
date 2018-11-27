# Course 130 notes for assessment
# ---------------------------------------------------

# & UNARY OPERATOR

# in ruby the & operator can mean different things depending on how it's used.

# if & is used prefixed on the final parameter in a method definition parameter list, this tells ruby to expect 
# a proc object or to convert the block into a named 'simple proc'.
# This allows you to pass the named proc object around to other methods, making it
# more flexible, unlike only having yield to execute the blocks when passed implicitly.

# if & is used in a method invocation it doesn't treat that argument as a normal argument,
# but rather it's used to create a Proc object by calling #to_proc, which is then used as the explicitly named or implicit block argument that all methods can
# accept.

# & can be invoked by symbols. Symbols have their own implementation of to_proc, which creates a proc that has a single 
# parameter. the parameter then invokes an instance method, named after the symbol that originally called &.

# line 2 lines below perform the same operation and illistrates my point above. 

arr = %w[a b c d]

arr.each(&:upcase)
arr.each { |x| x.upcase }


def my_select(arr, &named_block)
  count = 0
  result = []

  loop do
    block_result = named_block.call arr[count] # the block can also be yielded to normally
    result << arr[count] if block_result

    count += 1
    break if count >= arr.length
  end
  result
end

arr = [1, 2, 3, 4, 5]
proc_obj = Proc.new { |num| num.odd? }

 p my_select(arr, &proc_obj)

# --------------------------------------------------

# CLOSURES

# In ruby a closure is a 'chunk of code' that can be 'saved' for later execution.  Closures in ruby are
# Blocks, Procs, and Lambdas.  Closures also save and can access the context of where it was created, meaning, the closure keeps track of all instantiated objects, classes, 
# and constants within the scope, which the Closure was created.  Also if any of those tracked object are mutated or reassigned,
# those changes are reflected within the closure.

def test_method
  'abc'
end

x = 12

CONST = 'never changes'

closure = Proc.new do
  puts "This Proc saves the context of the method test_method, the x variable, and the CONST constant" 
  puts test_method
  puts x
  puts CONST
end

y = 'this string is not available to the Proc object being pointed to by the variable named clousre'

closure.call

# --------------------------------------------------

# BLOCKS

# Blocks are a type of closure. A closure creates a lexical scope. However unlike Procs and Lambdas blocks are not an object in ruby.  Blocks
# are used as a chunk of code that can be executed later. blocks are passed as the final argument to a method
# invocation.  All methods, even custom methods can implicitly or explicitly accept a block. A blocks airity is not strict
# and does not enforce parameter and argument count to be equal. If you supply too many parameters, ruby will assign nil to it.
# if you supply more arguments than block parameters, ruby will ignore, leaving you unable to access that argument.

[1,2,3].map { |x, y| y } # => [nil, nil, nil]

# ---------------------------------------------------

# SPLAT IN DEFINITION

# if you use a splat in a method definition, when you make an invocation on that method, ruby automatically assigns the correct argument to parameter variable
# on either sides of the splat variable name, and assigns the remaining arguments to the splat parameter variable. when you use a splat in method definition
# it becomes an optional argument and will assign an empty arr if it is provided no arguments. airity of the other parameters must be satisfied, and will throw an
# ArgumentError if the arguments are less than the number of the non splat parameter variables.

#ex

def test_splat(arg1, arg2, *splat, last_arg)
  p arg1 # 1
  p arg2 # 2
  p splat # [3,4,5,6]
  p last_arg # 7
end

test_splat(1,2,3,4,5,6,7)


# --------------------------------------------------





# TESTING

# When talking about testing there are a few terms within the testing purview.

# Test Suite: is the entire series of tests for a program (the collection of individual tests).

# Test: is the specific situation, scenario or context of what need to be tested. You set up objects 
# to be tested for accuracy. Accuracy of its state and behavior. 

# Assertion: The actual test and verification method that compares the result from the test subject and the expectation.  
# This checks that expectations and actual results are the same.

# MiniTest has 2 special methods named setup, and teardown.  both these methods are invoked before (setup) and after (teardown) each individual test
# in the test suite.  The setup method allows you to create the 'boiler plate' scenario that most or all of your tests share, by instantiating objects and assigning them to instance variables
# to be used in the subsequent tests.  When the test finishes running, the teartown method is invoked, so the programmer can do cleanup such as close files that were opened for the test.

# you can skip a test by putting the keyword skip at the beginning of a test

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'abc'

class AbcTest < Minitest::Test
  def test_abc
    assert('abc', abc)
  end
end

# --------------------------------------------------

# SEAT APPROACH

# S- Setup the nescessary objects
# E- Execute the code against aforementioned objects
# A- Assert that the actual results match expectations
# T- Teardown and lingering artifacts, general cleanup like closing files.

# --------------------------------------------------

# SETUP

# the setup method is invoked before every single test.  This is where you create the objects nescessary to run your individual tests.
# all of your individual tests are just instnace methods of your test suite class.  Being they are instance methods,
# they create their own scope, and in order to use the objects created in the setup method, they must be initialized as an instance variable and not a local variable.

require 'simplecov'
SimpleCov.start

require 'minitest/autorun'

require 'minitest/reporters'
MiniTest::Reporters.use!

require_relative 'abc'

class AbcTest < Minitest::Test
  def setup
    @abc = abc
  end

  def test_abc
    assert('abc', @abc)
  end
end

# Line 115 looks similar to the assertion on line 119, except on line 155 it references the instnace variable @abc, which was created in the setup method and was assigned the
# return value of the method abc. Whereas line 119 directly calls the method abc.

# ---------------------------------------------------

# ASSERTIONS

# Assertions are actual test. it's a series of verification methods that compare the result from the test subject and the expectation.  
# This checks that expectations and actual results are true in the context of the specific assertion. If the comparison is true within the context of the assertion, the assertion passes.
# if the comparison is false, the assertion fails.

# assertions come in many flavors. one checks for exact output (assert_output(expected string) {code that outputs}), 
# one checks if the tested object is an instance of a certain class (assert_instance_of(class, obj)), 
# one checks that the 2 arguments are of equal value (assert_equal(obj1, obj2)).  The point is there are dozens at your disposal.

# ---------------------------------------------------

# ASSERT_EQUAL

# this assertion the first argument invokes its class specific `==` method and uses the second assertion argument as the argument for the == method that the assertion invokes.
# if == returns true, the assertion passes.  If you are using a custom class you need to redefine the == method, otherwise when you compare 2 instantiated objects of the same custom class, 
# the assertion fail and will inform you to implement a == method of its own, so as not use the inherited == that tests object equality instead of value equality.


