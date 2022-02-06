class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# @@cats_count is a class variable, ie a single variable shared by each object of the class.
# It is initialized at 0 on line 2, when Ruby reads in the code.
# It is incremented on line 7 each time a new Cat object is instantiated.
# We can access its value by calling the class method self.cats_count like so:
# Cat.cats_count
