class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    self.process_name(full_name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end
  
  def name=(name)
    self.process_name(name)
  end
  
  private
  
  def process_name(name)
    parts = name.split
    self.first_name = parts.first
    self.last_name = parts.size > 1 ? parts.last : ''
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'
