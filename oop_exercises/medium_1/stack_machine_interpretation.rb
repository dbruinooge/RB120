class Minilang
  METHODS = %w(PUSH ADD SUB MULT DIV MOD POP PRINT)
  METHODS_REQUIRING_STACK = %w(ADD SUB MULT DIV MOD POP)
  
  def initialize(argument)
    @register = 0
    @stack = []
    @arguments = argument.split
  end
  
  def eval
    @arguments.each do |argument|
      if argument.to_i.to_s == argument
        @register = argument.to_i
      else
        raise EmptyStackError, "Empty stack!" if insufficient_stack?(argument)
        raise InvalidTokenError, "Invalid token: #{argument}" if METHODS.none?(argument)
        send(argument.downcase)
      end
    end
  end
  
  private

  def push
    @stack << @register
  end
  
  def add
    @register += @stack.pop
  end
  
  def sub
    @register -= @stack.pop
  end
  
  def mult
    @register *= @stack.pop
  end
  
  def div
    @register /= @stack.pop
  end
  
  def mod
    @register %= @stack.pop
  end
  
  def pop
    @register = @stack.pop
  end
  
  def print
    puts @register
  end
  
  def insufficient_stack?(argument)
    METHODS_REQUIRING_STACK.include?(argument) && @stack.empty?
  end
end

class InvalidTokenError < StandardError
end

class EmptyStackError < StandardError
end

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

# Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

# Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)
