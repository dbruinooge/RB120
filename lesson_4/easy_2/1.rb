class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

# What is the result of executing the following code:

oracle = Oracle.new
oracle.predict_the_future

# Line 13 creates a new Oracle object.
# Line 14 returns a string concatenation of "You will " and 
# a random element of the array on line 7.
