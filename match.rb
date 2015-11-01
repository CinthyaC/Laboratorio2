class Match

  attr_accessor :id, :name, :description, :result, :state, :team_a, :team_b, :news, :suspended

  def initialize
    @news = []
    @suspended = []
  end

end