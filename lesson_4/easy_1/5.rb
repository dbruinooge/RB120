# Which of these two classes has an instance variable and how do you know?

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# The @name variable in class Pizza is an instance variable, which is indicated by the @ symbol preceding the variable name.
