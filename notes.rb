# Course 130 notes for assessment
# ---------------------------------------------------

# & UNARY OPERATOR

# in ruby the & operator can mean different things depending on how it's used.

# if & is used prefixed in a method definition parameter list, this tells ruby to expect 
# a proc object or to convert the block into a named 'simple proc'.
# This allows you to pass the named proc object around to other methods, making it
# more flexible, unlike only having yield to execute the blocks when passed implicitly.

# if & is used in a method invocation it doesn't treat that argument as a normal argument,
# but rather it's used to create a Proc object by calling to_proc, and then used as the implicit or explicitly named block that all methods can
# accept.

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