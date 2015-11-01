class Player

  attr_accessor :ci, :name, :birthdate, :position, :interceptions, :goals, :small_box_goals, :percentaje_passes, :percent_effectiveness

  def initialize(ci, name, birthdate, position)
    @ci = ci
    @name = name
    @birthdate = birthdate
    @position = position
    
  end
  
  
end