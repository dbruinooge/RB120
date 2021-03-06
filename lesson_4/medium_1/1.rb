class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end
end

# Ben is right. `balance` on line 9 invokes the getter method
# created by `attr_reader :balance` on line 2.
