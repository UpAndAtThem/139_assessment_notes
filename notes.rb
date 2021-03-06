# Course 130 notes for assessment
# ---------------------------------------------------

# NAMED BLOCK PARAMETER (& UNARY OPERATOR)

# in ruby the & operator can mean different things depending on how it's used.

# if & is used prefixed on the final parameter in a method definition parameter list, this tells ruby to expect 
# a block, or a & prefixed object that has an implementation of #to_proc, that it converts into a named Proc object. This allows you to 
# pass the block (which is now a Proc) around to other methods, making it more flexible, extending block execution to a process other than only having yield to 
# execute the block when passed implicitly.

# if & is used in a method invocation it doesn't treat that argument as a normal argument, 
# but rather it's used to create a Proc object by calling #to_proc, which is then used as the explicitly 
# named or implicit block argument that all methods can accept.

# & can be invoked by symbols. Symbols have their own implementation of to_proc, which creates a proc that
# has a single parameter. the parameter then invokes an instance method, named after the symbol that 
# originally called &.

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
# Blocks, Procs, and Lambdas.  Closures also save and can access the context of where it was created, meaning, 
# the closure keeps track of all instantiated objects, classes,  and constants within the scope, which the 
# Closure was created.  Also if any of those tracked object are mutated or reassigned, those changes are 
# reflected within the closure, this is called its binding. All objects within the scope the closure was created are bound to the closure.

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

# Blocks are a type of closure. when created, blocks create a local scope, and forms a binding to the objects available to the scope which the block was created. 
# Meaning objects within the scope where the block was created, can still be accessed within the block, even when the block is executed 
# in a different scope entirely (such as a local method scope) This is called binding. However unlike Procs and Lambdas blocks are not 
# an object in ruby.  Blocks are used as a chunk of code that can be executed later. blocks are passed as the final 
# argument in a method invocation.  All methods, even custom methods can implicitly or explicitly accept a block. 
# A blocks airity is not strict and does not enforce parameter and argument count to be equal. If you supply 
# too many parameters, ruby will assign nil to it. if you supply more arguments than block parameters, 
# ruby will ignore, leaving you unable to access that argument.

# WHEN TO USE BLOCKS

# blocks are useful when 
# 1. you need to implement some sort of before / after function.
# 2. Defer some implementation code at method invocation.


[1,2,3].map { |x, y| y } # => [nil, nil, nil]


# ---------------------------------------------------

# BLOCKS VARIABLE SCOPE

# A block creates a new scope for local variables, and only outer local variables are accessible to inner blocks.

outer = 'outer most variable'

3.times do |index|
  inner = 'inner variable'

  ['a', 'b', 'c'].each do |letter|
    inner_most = 'inner most variable'
  end
end

# all 3 variables (outer, inner, inner_most) are accessible within the local variable scope created by the block passed to the each method within' 
# the block passed to times.  Within the times block only 2 local variables (inner and outer) are available within the scope created by the block.  
# Within the outermost local variable scope, only 1 local variable (outer) is available within that scope.  Only local variables follow these scoping rules.


# ---------------------------------------------------

# &:SYMBOL

# When invoking a method that takes a block you can use the shorthand &:method_name_symbol.  When ruby sees this, Symbol#to_proc is executed, and creates a proc object
# and is then converted and used as a block argument.

# EX: 

[1, 2, 3].map(&:to_s) #is the shorthand version of the invocation 1 line below
[1, 2, 3].map { |x| x.to_s }

# & can be invoked by symbols. Symbols have their own implementation of to_proc, which creates a proc that
# has a single parameter. The parameter variable local to the block then invokes an instance method, named after the symbol that 
# originally called &.

# this shorthand only works when the method name represented as a symbol in the shorthand doesn't take any arguments when normally executed.


# ----------------------------------------------------

# SPLAT IN DEFINITION

# if you use a splat in a method definition, when you make an invocation on that method, ruby automatically assigns the correct argument to parameter variable
# on either side of the splat variable name, and assigns the remaining arguments to the splat parameter variable. when you use a splat in method definition
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

# AIRITY

# Airty is the strictness levels pertaining to the enforcement of argument length and parameter list length equality.
# Low airity means the number of arguments and the number of parameters in the list do not need to be equal.
# High airity means the number of arguments and the number of parameters in the list need to be equal.
# Procs are like blocks, they have low airity, they don't care about argument and parameter equality.
# Lambdas are more like methods, they must match argument length and parameter list length. Will throw ArgumentError if not satisfied.
# in procs if you give too many arguments, ruby ignores the extra arguments.  If you give too few arguments ruby will assign nil to the parameter variables not provided an argument.

lam = lambda { |x, y| y}
pro = Proc.new { |x, y, z| z}

pro.call "hello", "world" #=> nil
lam.call "hello", "world" # => "world"
lam.call "hello" # ArgumentError expecting 2 arguments given 1
# ---------------------------------------------------

# LOCAL JUMP ERROR

# a LocalJumpError is an exception that is raised when a method yields to a block when no block was included
# in the method invocation.

def test(&block)
  yield "hello world"
  block.call "way to yield to named block"
end

test { |x| p x}

test # LocalJumpError is raised because no block was provided

# You can avoid LocalJumpErrors by implementing control flow to check if a block was given using a conditional with Kernel#block_given?


# -----------------------------------------------------

# TESTING

# When talking about testing there are a few terms within the testing purview.

# Test Suite: is the entire series of tests for a program (the collection of individual tests).

# Test: is the specific situation, scenario or context of what needs to be tested. You set up objects 
# to be tested for accuracy. Accuracy of its state and behavior. Test names begin with test_, which tells MiniTest this
# is an individual test that needs to be ran.

# Assertion: The actual test and verification method that compares the result from the test subject and the expectation.  
# This checks that expectations and actual results are the same.

# MiniTest has 2 special methods named setup, and teardown.  both these methods are invoked before (setup) and after (teardown) each individual test
# in the test suite.  The setup method allows you to create the 'boiler plate' scenario that most or all of your tests share, by instantiating objects and assigning them to instance variables
# to be used in the subsequent tests.  When the test finishes running, the teartown method is invoked, so the programmer can do cleanup such as close files that were opened for the test.

# you can skip a test by putting the keyword skip at the beginning of a test

require 'simplecov'
SimpleCov.start

require 'minitest/autorun' # loads all the nescessary files to run MiniTest

require 'minitest/reporters' # gem that adds color output to testsuite output
MiniTest::Reporters.use!

require_relative 'abc' # File we are testing below

class AbcTest < Minitest::Test # AbcTest inheriting the Test class from MiniTest module
  def setup
    @abc = 'abc'
  end

  def test_abc
    assert('abc', @abc)
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

# ---------------------------------------------------

# ASSERTIONS

# Assertions are actual test. it's a series of verification methods that compare the result from the test subject and the expectation.  
# This checks that expectations and actual results are true in the context of the specific assertion. If the comparison is true within the context of the assertion, the assertion passes.
# if the comparison is false, the assertion fails.

# assertions come in many flavors. one checks for exact output (assert_output(expected string) {code that outputs}), 
# one checks if the tested object is an instance of a certain class (assert_instance_of(class, obj)), 
# one checks that the 2 arguments are of equal value (assert_equal(obj1, obj2)).  The point is there are dozens at your disposal, specifically defined based on the type of test needed.

assert(test)  # Fails unless test is truthy.
assert_equal(exp, act)  # Fails unless exp == act.
assert_same(exp, act) # same object
assert_nil(obj) # Fails unless obj is nil.
assert_raises(*exp) { "code that raises an Exception which matches the argument in method invocation." } # Fails unless block raises one of *exp.
assert_instance_of(cls, obj)  # Fails unless obj is an instance of cls.
assert_includes(collection, obj) #Fails unless collection includes obj.

# ---------------------------------------------------

# ASSERT_EQUAL

# this assertion the first argument invokes its class specific `==` method and uses the second assertion 
# argument as the argument for the == method that the assertion invokes. if == returns true, the assertion 
# passes.  If you are using a custom class you need to redefine the == method, otherwise when you compare 
# 2 instantiated objects of the same custom class, the assertion fail and will inform you to implement a ==
#  method of its own, so as not use the inherited == that tests object equality instead of value equality.


# ----------------------------------------------------

# RVM (ruby version manager)

# This gem manages multiple versions of Ruby on the same device. You can configure it to use a specified 
# default version within individual directories, making it easy to set default versions based on
# which directory you are currently working in.  

# version managers are useful becasue it allows you install and use different versions of ruby, 
# as well as the ability to easily and quickly switch between multiple installations of Ruby.

# -----------------------------------------------------

# BUNDLER

# Bundler is a gem manager for projects. It specifies which version of Ruby is used for the project, and downloads all of the dependencies (gems) and use the versions that are compatable to one another.  
# Bundler takes a file named Gemfile and based on the contents creates a Gemfile.lock file which documents the dependencies and the versions
# downloaded for this project, as well as the version of the project, path information, and the version of bundler used. A Gemfile defines and contains info such as the source from which to download the gems, a list of gems needed for the project,
# the ruby version number, a .gemspec file (needed for deployment).

# GEMFILE

# a Gemfile gives spells out explicitly about a projects Ruby version as well as the Gem versions required. It's the config file that Bundler uses to know what gems, 
# and which versions to install based on the specifics defined by the programmer, written in its domain specific syntax, that bundler can parse.

# GEMFILE.LOCK

# After you create a Gemfile for the project, and bundle install, a Gemfile.lock file is created. Gemfile.lock documents all the dependencies 
# that your program requires; this includes the Gems listed in Gemfile, as well as the Gems they depend on (the dependencies)

# ------------------------------------------------------

