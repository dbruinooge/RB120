class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

hello = Hello.new
hello.hi

# The above outputs "Hello"

hello = Hello.new
hello.bye

# The above raises an error because there is no #bye method available to the Hello class

hello = Hello.new
hello.greet

# The above raises an exception because of improper number of arguments (given 0, expected 1)

hello = Hello.new
hello.greet("Goodbye")

# The above outputs "Goodbye"

Hello.hi

# The above raises an error, since there is no such class method (#hi is an instance method)
