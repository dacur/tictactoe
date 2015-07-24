# Player 1 is X, Player 2 is O

class Game
	attr_accessor :first

	def initialize
		@board = Board.new
		@available = [1,2,3,4,5,6,7,8,9]
		@player_moves = []
		@robot_moves = []
		@winning_combos = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
		@preferred_spaces = [5,1,3,7,9,2,4,6,8]
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
			choose
		elsif @first == "n"
			"Okay, I will go first!\n".slow
			@first = false
			robot_turn
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
			@player_moves.push(@choice.to_i)
			@board.play(@choice, "X")
			@current_player = "player"
			check_status(@player_moves)
			robot_turn
		else
			"#{@choice} is not available! Please choose again.\n".slow
			choose
		end
	end

	def check_status(moves)
		@moves = moves.sort
		puts "Moves are #{@moves}"
		@winning_combos.each do |wc|
			wc = wc - @moves
			if wc.empty?
				game_over
			end
		end
		if @available == []
			puts "It's a tie!"
			play_again?
		end
	end

	def play_again?
		"Would you like to play again (y/n)? ".slow
		play = gets.chomp.downcase
		if play == "y"
			initialize
			goes_first?
		elsif play == "n"
			exit
		else
			play_again?
		end
	end

	def game_over
		if @current_player == "player"
			puts "You win!"
			play_again?
		else
			puts "Haha, I win!"
			play_again?
		end
	end

	def robot_turn
		#loop through winning combos and see if player moves contains 2 of 3. if so, play 3rd space.  if not, play 1st preferred space available.
		@choice = nil
		@winning_combos.each do |wc|
			@remainder = wc - @player_moves
			if @remainder.size == 1 && @available.include?(@remainder[0])
				puts "Player is about to win! Play #{@remainder[0]}"
				@choice = @remainder[0]
				break
			end
		end

		@winning_combos.each do |wc|
			@remainder = wc - @robot_moves
			if @remainder.size == 1 && @available.include?(@remainder[0])
				puts "I'm going to win! Play #{@remainder[0]}"
				@choice = @remainder[0]
				break
			end
		end

		if @choice == nil
			"Nothing to see here. Choosing best remaining space."
			preferred_remaining = @preferred_spaces - (@player_moves + @robot_moves)
			@choice = preferred_remaining[0]
		end


		@available = @available - [@choice.to_i]
		
		"I choose space #{@choice}.\n".slow
		@robot_moves.push(@choice.to_i)
		@board.play(@choice, "O")
		@current_player = "robot"
		check_status(@robot_moves)
		choose #player's turn
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
		@current_board = []
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
		"I'm going to start off by showing you the playing board.\n".slow
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

