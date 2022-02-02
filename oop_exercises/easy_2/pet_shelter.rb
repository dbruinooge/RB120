class Shelter
  attr_reader :adoptions, :pets
  
  def initialize(pets)
    @pets = pets
    @adoptions = {}
  end
    
  def adopt(owner, pet)
    owner.add_pet(pet)
    adoptions[owner.name] ||= []
    adoptions[owner.name] << pet
    pets.delete(pet)
  end
  
  def print_adoptions
    adoptions.each do |owner, pets|
      puts "#{owner} has adopted the following pets:"
      pets.each do |pet|
        puts pet
      end
    end
  end
  
  def display_unadopted
    puts "The Animal Shelter has the following unadopted pets:"
    @pets.each do |pet|
      puts pet
    end
  end
  
  def number_unadopted
    @pets.size
  end
end

class Owner
  attr_reader :pets
  attr_reader :name
  
  def initialize(name)
    @name = name
    @pets = []
  end
  
  def number_of_pets
    pets.size
  end
  
  def add_pet(pet)
    @pets << pet
  end
end

class Pet
  attr_reader :type, :name
  
  def initialize(type, name)
    @type = type
    @name = name
  end
  
  def to_s
    "a #{type} named #{name}"
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
harry        = Pet.new('cat', 'Harry')
fido         = Pet.new('dog', 'Fido')

pets = [butterscotch, pudding, darwin, kennedy,
        sweetie, molly, chester, harry, fido]

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new(pets)
shelter.display_unadopted
puts "The Animal Shelter has #{shelter.number_unadopted} unadopted pets."
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
shelter.display_unadopted
puts "The Animal Shelter has #{shelter.number_unadopted} unadopted pets."
