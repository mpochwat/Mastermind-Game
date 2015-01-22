class Board
	attr_accessor :codebreaker, :codemaker

	def initialize
		@codebreaker = Codebreaker.new
		@turns = 1
	end

	def guess_match
		if @codebreaker.code_pegs == @codebreaker.codemaker.code_pegs
			true
		end
	end

	def guess_check
		black_pegs = num_black_pegs
		white_pegs = num_white_pegs - black_pegs
		puts "Displayed #{black_pegs} black keypegs and #{white_pegs} white keypegs. Try again!"
	end		

	def num_black_pegs
		black_pegs = 0
		for i in 0..3
			if @codebreaker.code_pegs[i] == @codebreaker.codemaker.code_pegs[i]
				black_pegs += 1
			end
		end
		black_pegs
	end

	def num_white_pegs
		white_pegs = 0
		counts = Hash.new(0)
		
		@codebreaker.code_pegs.each { |color| counts[color] += 1 }

		@codebreaker.codemaker.code_pegs.each do |color|
			if counts.has_key?(color) && counts[color] > 0
				white_pegs += 1
				counts[color] -= 1
			end
		end
		white_pegs
	end	

	def check_game
		if @turns == 12 # 12 turns, end of game.
			@codebreaker.codemaker.add_point
			@codebreaker.codemaker.add_point
			puts " "
			puts "The secret code was: #{@codebreaker.codemaker.code_pegs}"
			total_points
			true
		elsif guess_match # guess == secret code, end of game.
			puts " "
			puts "You guessed the combination. Great job!"
			total_points
			true
		else # add 1 point to codemaker and continue next round.
			guess_check
			@codebreaker.codemaker.add_point
			@turns += 1
			total_points
			false
		end
	end

	def total_points
		# Total of 13 points to be split among CodeMaker & CodeBreaker.
		breaker_points = 13 - @codebreaker.codemaker.points 
		puts "Codemaker: #{@codebreaker.codemaker.points} points"
		puts "Codebreaker: #{breaker_points} points"
	end
end


class CodePeg
	attr_accessor :color

	def initialize(num)
		@color = colors[num]
	end

	def colors
		colors = {0 => 'red', 1 => "blue", 2 => "green",
				  3 => 'orange', 4 => "purple", 5 => "white"}
	end
end


class Codebreaker
	attr_accessor :codemaker

	def initialize
		@codemaker = Codemaker.new
		@points = 0
		@peg1 = ''
		@peg2 = ''
		@peg3 = ''
		@peg4 = ''
		@guesses = [] # Keeps track of current & previous guesses
	end

	def guess_human
		puts " "
		puts "---------------------------------------------------------------"
		puts "Using the codes below, guess the 1st peg:"
		puts "0 = red, 1 = blue, 2 = green, 3 = orange, 4 = purple, 5 = white"
		guess1 = gets.chomp.to_i
		puts "Guess the 2nd peg:"
		guess2 = gets.chomp.to_i
		puts "Guess the 3rd peg:"
		guess3 = gets.chomp.to_i
		puts "Guess the 4th peg:"
		guess4 = gets.chomp.to_i
		@peg1 = CodePeg.new(guess1)
		@peg2 = CodePeg.new(guess2)
		@peg3 = CodePeg.new(guess3)
		@peg4 = CodePeg.new(guess4)
		@guesses << code_pegs
		puts " "
		all_guesses
	end

	def guess_computer_first # First guess for computer
		@peg1 = CodePeg.new(rand(6))
		@peg2 = CodePeg.new(rand(6))
		@peg3 = CodePeg.new(rand(6))
		@peg4 = CodePeg.new(rand(6))
		@guesses << code_pegs
		puts " "
		all_guesses
	end	

	def guess_computer # Used for following guesses. Includes AI.
		computer_AI_peg1
		computer_AI_peg2
		computer_AI_peg3
		computer_AI_peg4
		@guesses << code_pegs
		puts " "
		all_guesses
	end		

	# If 1st peg for codebreaker matches 1st peg for codemaker, do not change.
	def computer_AI_peg1
		if @peg1.color == @codemaker.peg1.color
			@peg1
		else
			@peg1 = CodePeg.new(rand(6))
		end
	end

	def computer_AI_peg2
		if @peg2.color == @codemaker.peg2.color
			@peg2
		else
			@peg2 = CodePeg.new(rand(6))
		end
	end

	def computer_AI_peg3
		if @peg3.color == @codemaker.peg3.color
			@peg3
		else
			@peg3 = CodePeg.new(rand(6))
		end
	end

	def computer_AI_peg4
		if @peg4.color == @codemaker.peg4.color
			@peg4
		else
			@peg4 = CodePeg.new(rand(6))
		end
	end			

	def code_pegs
		pegs = [@peg1.color, @peg2.color, @peg3.color, @peg4.color]
	end

	def all_guesses
		guess_num = 1
		@guesses.each do |guess|
			puts "Guess #{guess_num}: #{guess}"
			guess_num += 1
		end
	end

	def points
		@points
	end
end


class Codemaker
	attr_accessor :peg1, :peg2, :peg3, :peg4, :points

	protected

	def initialize 
		@points = 0
		# Initialized for case where computer = Codemaker
		@peg1 = CodePeg.new(rand(6))
		@peg2 = CodePeg.new(rand(6))
		@peg3 = CodePeg.new(rand(6))
		@peg4 = CodePeg.new(rand(6))
	end

	public

	def set_code # Used when human is Codemaker
		puts " "
		puts "---------------------------------------------------------------"
		puts "Using the codes below, set secret color for the 1st peg:"
		puts "0 = red, 1 = blue, 2 = green, 3 = orange, 4 = purple, 5 = white"
		set1 = gets.chomp.to_i
		puts "Set secret color for the 2nd peg:"
		set2 = gets.chomp.to_i
		puts "Set secret color for the 3rd peg:"
		set3 = gets.chomp.to_i
		puts "Set secret color for the 4th peg:"
		set4 = gets.chomp.to_i
		@peg1 = CodePeg.new(set1)
		@peg2 = CodePeg.new(set2)
		@peg3 = CodePeg.new(set3)
		@peg4 = CodePeg.new(set4)
		puts "You have set the following combination:"
		print code_pegs
		puts " "
	end

	def code_pegs
		pegs = [@peg1.color, @peg2.color, @peg3.color, @peg4.color]
	end

	def add_point
		@points += 1
	end

	def points
		@points
	end
end


play_again = "y"

#Loop to play again
while play_again == "y"
	game_over = false
	play = Board.new()

	puts 'Do you want to be the "CodeBreaker" OR "CodeMaker"?'
	ans = gets.chomp.to_s.downcase

	# Ensures user selects CodeBreaker OR CodeMaker
	while (ans != "codebreaker") && (ans != "codemaker")
		puts " "
		puts "Invalid response. Try again."
		puts 'Do you want to be the "CodeBreaker" OR "CodeMaker"?'
		ans = gets.chomp.to_s.downcase
	end

	# CodeBreaker game
	if ans == "codebreaker"
		while !game_over
			play.codebreaker.guess_human
			game_over = play.check_game
		end

	# Codemaker game	
	else ans = "codemaker"
		play.codebreaker.codemaker.set_code
		play.codebreaker.guess_computer_first # different command 1st round
		game_over = play.check_game
		while !game_over
			play.codebreaker.guess_computer # same command for remaining rounds
			game_over = play.check_game
		end
	end

	puts "Play again? (y/n)"
	play_again = gets.chomp.to_s.downcase
end
