class Board
  attr_accessor :values

  def initialize
    @values = Hash.new
    (1..7).to_a.each do |i|
      @values[i] = Array.new(6)
    end
  end

  def display
    puts 
    for row in 5.downto(0) do
      print "   "
      for column in 1..7
        if values[column][row].nil?
          print "\u25cb "
        else
          print values[column][row]
        end
      end
      print "\n"
    end
    puts "   1 2 3 4 5 6 7"
    puts
  end
end