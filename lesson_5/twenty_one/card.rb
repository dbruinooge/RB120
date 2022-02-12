class Card
  attr_reader :value

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value} of #{suit}"
  end

  private

  attr_reader :suit
end
