require_relative 'championship'
require_relative 'team'
require_relative 'player'
require_relative 'action'

class Program

  def initialize
    @championship = Championship.new
  end

  def set_championship(name, teams_size)
    @championship.teams_size = teams_size
    @championship.name = name
  end

  def championship_can_be_played
    can_play = nil

    if @championship.teams.size == 0
      can_play = 'No hay equipos'
    elsif @championship.teams.size % 2 == 1
      can_play = 'La cantidad de equipos es inpar'
    elsif false
      can_play = 'La cantidad de jugadores es menor a la permitida en el campionato'
    end
    
    can_play
  end

  def championship_start
    @championship.start = true
  end

  def championship_name
    @championship.name
  end

  def championship_started?
    if @championship.start
      start = true
    else
      start = false    
    end

    start
  end

  def add_team(team_name)
    team = nil

    while !team
      team = Team.new(team_name)
      if error = @championship.can_add_team(team)
        team = nil
      else
        return nil
      end
    end

    @championship.add_team(team)
  end

  def add_player(ci, name, birthdate, position)
    player = nil

    while !player

      player = Player.new(ci, name, birthdate, position)
      if error = @championship.can_add_player(player)
        player = nil
      else
        return nil
      end
    end

    @championship.add_player(player)
  end

  def add_player_to_team(team_name, player_id)
    team = @championship.teams.find { |t| t.name == team_name}
    player = @championship.players.find { |p| p.id == player_id}

    if team.players.find { |p| p.position == 'Arquero' }
      return 'se quiere agregar un arquero cuando ya existe uno para ese equipo.'
    elsif team.players.find { |p| p.position == 'Arquero' } && team.players.find { |p| p.position == 'Defensa' } && team.players.find { |p| p.position == 'Volante' } && team.players.find { |p| p.position == 'Delantero' }
      return 'El equipo esta lleno.'
    else
      nil
    end

  end

  def player_list
    @championship.players
    #     [
    # {ci: "1111”, name: "Diego Godin”, birthdate: "01­02­1980”, position: "Defensa”,
    # interceptions: 10},
    # {ci: "2222”, name: "Fernando Muslera”, birthdate: "01­02­1980”, position: "Arquero”,
    # goals: 10, small_box_goals: 2},
    # {ci: "3333”, name: "Carlos Sanchez”, birthdate: "01­02­1980”, position: "Volante”, goals:
    # 3, percentaje_passes: 90},
    # {ci: "4444”, name: "Luis Suarez”, birthdate: "01­02­1980”, position: "Delantero”, goals:
    # 10, percent_effectiveness: 100 }
    # # ]
    list = []
    @championship.players.each do |p|
      list << {ci: p.ci, name: p.name, birthdate: p.birthdate, position: p.position}
      case p.position
      when 'Defensa'
        list.marge({interceptions: p.interceptions})
      when 'Arquero'
        list.marge({goals: p.goals, small_box_goals: p.small_box_goals})
      when 'Volante'
        list.marge({goals: p.goals, percentaje_passes: p.percentaje_passes})
        when 'Delantero'
        list.marge({goals: p.goals, percent_effectiveness: p.percent_effectiveness})        
      end 
    end


  end

  def team_list
    list = []
    @championship.teams.each { |t| list << {name: t.name } }
    list
  end

  def matches_list
    array = []

    @championship.matches.each { |match| array << { id: match.id, description: match.description, result: match.result, state: match.state } }#creo q puede andar

    array
  end

  def get_match(match_id)

    @championship.matches.each do |match|
      if match.id == match_id
        hash = {
          state: match.state,
          description: match.description,
          result: match.result,
          team_a: match.team_a.name,
          team_b: match.team_b.name,
          news: match.news
        }
      end

    end

  end

  def start_match(match_id)
      @championship.matches.each do |match|
      if match.id == match_id
        match.state = :in_game
      end
    end
  end


  def end_match(match_id)
    @championship.matches.each do |match|
      if match.id == match_id
        match.state = :finish
      end
    end
  end

  def available_players_list_for_match(match_id, team_name)
    match = @championship.matches.find { |m| m.id == match_id}
    team = @championship.teams.find { |t| t.name == team_name}
    if match.team_a.name == team.name or match.team_b.name == team.name
      avilable = team.player - match.suspended
      avilable.each do |player|
        {
        ci: player.ci, 
        name: player.name,
        }
      end
    else
        nil
    end
  end

  def add_match_action(match_id, team_name, player_id, action)
    match = @championship.matches.find { |m| m.id == match_id}
    match.news << Action.new(match_id, team_name, player_id, action)
  end

  def get_table_data
    table = []
    @championship.teams.each do |t|
      table << {
      team_name: t.name,
      played_matches: t.played_matches,
      won_matches: t.won_matches,
      drawn_matches: t.drawn_matches,
      lost_matches: t.lost_matches,
      goals_difference: t.goals_difference,
      points: t.points
      }
    end
    table.sort_by! { |t| t.points }

  end

  def get_news_data
    championship_news = []
    @championship.matches.each { |m| championship_news += m.news}
    championship_news
  end

  def players_list_for_team(team_name)
    players = []
    team = @championship.teams.find { |t| t.name == team_name}
    team.players.each { |p| players << {id: p.ci, name: p.name} }
    players
  end

  def players_without_team()
    without_team = @championship.players
    @championship.teams.each { |t| without_team -= t.players }
    players = []
    without_team.each { |p| players << {id: p.ci, name: p.name} }
    players
  end


end
