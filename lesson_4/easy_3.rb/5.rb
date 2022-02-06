class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
# The above will great a new Television object

tv.manufacturer
# This will give an error because there is no instance method #manufacturer
# (only a class method)

tv.model
# This invokes the #model method on the Television object referenced by tv

Television.manufacturer
# This invokes the #manufacturer class method on the Television class

Television.model
# This will give an error because there is no class method #model
# (only an instance method)
