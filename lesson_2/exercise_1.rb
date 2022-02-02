class Person
  attr_accessor :name
  
  def initialize(name)
    @name = name
  end
end

bob = Person.new('Bob')
puts bob.name

bob.name = 'Robert'
puts bob.name
