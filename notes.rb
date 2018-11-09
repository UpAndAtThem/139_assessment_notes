# Course 130 notes for assessment
# ---------------------------------------------------

# & UNARY OPERATOR

# in ruby the & operator can mean different things depending on how it's used.

# if & is used prefixed on the final parameter in a method definition parameter list, this tells ruby to expect 
# a proc object or to convert the block into a named 'simple proc'.
# This allows you to pass the named proc object around to other methods, making it
# more flexible, unlike only having yield to execute the blocks when passed implicitly.

# if & is used in a method invocation it doesn't treat that argument as a normal argument,
# but rather it's used to create a Proc object by calling to_proc, and then used as the implicit or explicitly named block that all methods can
# accept. (Ruby treats the Proc object as if it were just a regular block)

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

# In ruby a closure is a 'chunk of code' that can be 'saved' for later execution.  Closures are created by way of
# Blocks, Procs, and Lambdas.  Closures also save the context of where it was created. the closure keeps track of all instantiated objects, classes, 
# or anything that is visible to the scope where the Closure was created.  Also if any of those tracked object are mutated or reassigned,
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


