# Player 1 is X, Player 2 is O

class Game
	attr_accessor :first

	def initialize
		@board = Board.new
		@available = [1,2,3,4,5,6,7,8,9]
	end

	def start
		greet = Chatter.new
		greet.greeting
		greet.explain_board
		ready?
	end

	def ready?
		"Ready to play (y/n)? ".slow
		@ready = gets.chomp.downcase
		if @ready == "y"
			puts "Great!"
			goes_first?
		elsif @ready == 'board'
			@board.positions
			ready?
		else
			ready?
		end
	end

	def goes_first?
		"Would you like to go first (y/n)? ".slow
		@first = gets.chomp.downcase
		if @first == "y"
			"Great, you can go first!\n".slow
			@first = true
			play
		elsif @first == "n"
			"Great, I will go first!\n".slow
			@first = false
			play
		else
			goes_first?
		end
	end

	def choose
		"Choose an available position (1-9).\n".slow
		@choice = gets.chomp
		if @choice.match /^([1-9]?)$/
			"You chose #{@choice}.\n".slow
			add_choice
		else
			choose
		end
	end

	def add_choice
		if @available.include? @choice.to_i
			"#{@choice} is available!\n".slow
			@available = @available - [@choice.to_i]
			@board.play(@choice, "X")
			choose
		else
			"#{@choice} is not available! Please choose again.\n"
			choose
		end
	end

	def play
		@board.clean
		choose
	end
end

class Board
	def initialize
		@one = " "
		@two = " "
		@three = " "
		@four = " "
		@five = " "
		@six = " "
		@seven = " "
		@eight = " "
		@nine = " "
	end
	def clean
		puts "_|_|_\n_|_|_\n | | "
	end

	def positions
		puts "\e[4m1\e[0m|\e[4m2\e[0m|\e[4m3\e[0m\n\e[4m4\e[0m|\e[4m5\e[0m|\e[4m6\e[0m\n7|8|9"
	end

	def play(position, player)
		case position.to_i
		when 1
			@one = player
		when 2
			@two = player
		when 3
			@three = player
		when 4
			@four = player
		when 5
			@five = player
		when 6
			@six = player
		when 7
			@seven = player
		when 8
			@eight = player
		when 9
			@nine = player
		else 
			return
		end
		@current_board = ["\e[4m#{@one}\e[0m|","\e[4m#{@two}\e[0m|","\e[4m#{@three}\e[0m\n","\e[4m#{@four}\e[0m|","\e[4m#{@five}\e[0m|","\e[4m#{@six}\e[0m\n","#{@seven}|","#{@eight}|","#{@nine}\n"]
		@current_board.each do |b|
			print b
		end
	end
end

class String
	def slow
		each_char {|c| putc c ; sleep 0.01; $stdout.flush }
	end
end

class Chatter
	attr_accessor :name, :board

	def greeting
		"Hello! Welcome to TicTacToe. What is your name? ".slow
		@name = gets.chomp
		"Hello, #{@name}! My, you look \e[1msmashing\e[0m today!\n".slow
		"I'm going to start off by showing you the playing board. Any time you want to see it again, simply type 'board'.\n".slow
		@board = Board.new
		board.positions
	end

	def explain_board
		"The board consists of nine positions represented by the numbers 1 through 9.\n".slow
		"When it is your turn to play, simply enter the number of the open position you wish to play and then press Enter.\n"
	end

end

game = Game.new
game.start
# @one = @two = @three = @four = @five = @six = @seven = @eight = @nine = " "
# @five = "X"
# @five = "O"
# board = ["\e[4m#{@one}\e[0m|","\e[4m#{@two}\e[0m|","\e[4m#{@three}\e[0m\n","\e[4m#{@four}\e[0m|","\e[4m#{@five}\e[0m|","\e[4m#{@six}\e[0m\n","#{@seven}|","#{@eight}|","#{@nine}\n"]
# board.each do |b|
# 	print b
# end

