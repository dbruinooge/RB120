class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

garfield = AngryCat.new(3, 'Garfield')
claw = AngryCat.new(4, 'Claw')
