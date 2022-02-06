class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:

trip = RoadTrip.new
trip.predict_the_future

# Here, the RoadTrip class overwrites the #choices instance method from the Oracle class.
# Even though RoadTrip inherits #predict_the_future from the Oracle class, when that method is 
# executed by a RoadTrip object, Ruby will first look for a #choices method in the RoadTrip class 
# before checking the superclass.
# Therefore, the second element of the string concatenation will be a random element from the array
# on line 13.
