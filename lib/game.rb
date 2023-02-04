require_relative 'board'
require_relative 'player'


class Game
  attr_reader :player1, :player2, :board, :current_player

  WINING_COMBOS = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]

  def initialize
    @board = Board.new
    @player1 = Player.new("red", "\e[31m\u25cf\e[0m ")
    @player2 = Player.new("blue", "\e[34m\u25cf\e[0m ")
    @current_player = player1
  end

  def play
    until game_over?
      board.display
      play_round
      switch_player
    end
  end
  
  def player_input(column, symbol)
    board.values[column][board.values[column].index(nil)] = symbol
  end

  def play_round
    puts "#{current_player.name}'s turn!"
    begin
      column = select_column
    end while column_full?(column)
    player_input(column, current_player.symbol)
  end

  def column_full?(column)
    if board.values[column].none?(nil)
      puts "Column is full, please select other column."
      return true
    else
      return false
    end
  end
  
  def select_column
    puts "Enter number from 1 to 7:"
    begin
      column = gets.to_i
    end until (1..7).to_a.include?(column)
    column
  end

  def switch_player
    if current_player == player1
      @current_player = player2
    else
      @current_player = player1
    end
  end

  def game_over?
    taken_positions = []
    board.values.each do |column, row_array|
      row_array.each_index do |row|
        taken_positions << [column, row] if !row_array[row].nil?
      end
    end
    if taken_positions.any? { |position| check_all_directions(position) }
      board.display
      switch_player
      puts "#{current_player.name} has won the game!"
      true
    elsif taken_positions.length == 42
      board.display
      puts "Draw!"
      true
    else
      false
    end
  end

  def check_all_directions(position)
    WINING_COMBOS.any? { |direction| check_direction(direction, position)}
  end

  def check_direction(direction, position, counter = 1)
    return true if counter == 4
    return false if !(position[0] + direction[0]).between?(1, 7) || !(position[1] + direction[1]).between?(0, 5)
    return check_direction(direction, [position[0] + direction[0], position[1] + direction[1]], counter + 1) if board.values[position[0]][position[1]] == board.values[position[0] + direction[0]][position[1] + direction[1]]
    false
  end
end