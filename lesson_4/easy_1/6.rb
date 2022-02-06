# What could we add to the class below to access the instance variable @volume?

class Cube
  def initialize(volume)
    @volume = volume
  end
end

# We could add a getter method, either manually:
# def volume; @volume; end
# or using attr_reader:
# attr_reader :volume

# After reading the LS solution, I see that #instance_variable_get(variable)
# can also be used, although it is generally not a good idea to do so.
