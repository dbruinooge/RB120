require 'pry'
require './participant'

class AIPlayer < Participant
  NAMES = ['Bob', 'Jim', 'Kate', 'Sally', 'Dave', 'Susan']
  @@taken_names = []
  
  attr_reader :name
  
  def initialize
    super
    possible_names = NAMES.reject {|name| @@taken_names.include?(name) }
    @name = possible_names.sample
    @@taken_names << @name
    binding.pry
  end

  def ace_and_six?
    hand_values.include?('Ace') && hand_values.include?('6')
  end

  private

  def hand_values
    hand.map { |card| card.value }
  end
end