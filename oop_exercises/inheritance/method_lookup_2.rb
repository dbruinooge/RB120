class Animal
end

class Cat < Animal
end

class Bird < Animal
end

cat1 = Cat.new
cat1.color

# Because Ruby never finds a #color method, it goes all the way up the chain:
# Cat, Animal, Object, Kernel, BasicObject
