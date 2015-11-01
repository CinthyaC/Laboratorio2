class Championship
  attr_accessor :name, :teams_size, :teams, :start, :players, :matches

  def initialize
    @teams = []
    @players = []
    @matches = []
  end

  def can_add_team(new_team)
    team_with_same_name = @teams.find{ |team| team.name == new_team.name }
    if team_with_same_name
      return 'Ya hay un equipo con el nombre indicado'
    end
    return false
  end

  def can_add_player(new_player)
    player_with_same_ci = @players.find{ |player| player.id == new_player.id }
    if player_with_same_ci
      return 'Ya hay un jugador con la ci indicada'
    else
      return false
    end
  end

  def add_team(team)
    @teams << team
  end

  def add_player(player)
    @players << player
  end

end