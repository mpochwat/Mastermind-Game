class Board
	attr_accessor :codebreaker, :codemaker

	def initialize
		@codebreaker = Codebreaker.new
		@codemaker = Codemaker.new
		@turns = 1
	end

	def guess_match
		if (@codebreaker.code_pegs == @codemaker.code_pegs)
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
			if @codebreaker.code_pegs[i] == @codemaker.code_pegs[i]
				black_pegs += 1
			end
		end
		black_pegs
	end

	def num_white_pegs
		white_pegs = 0
		counts = Hash.new(0)
		
		@codebreaker.code_pegs.each { |color| counts[color] += 1 }

		@codemaker.code_pegs.each do |color|
			if counts.has_key?(color) && counts[color] > 0
				white_pegs += 1
				counts[color] -= 1
			end
		end
		white_pegs
	end	

	def check_game
		if @turns == 12 # 12 turns, end of game.
			@codemaker.add_point
			@codemaker.add_point
			total_points
			true
		elsif guess_match # guess == secret code, end of game.
			puts " "
			puts "You guessed the combination. Great job!"
			total_points
			true
		else
			guess_check
			@codemaker.add_point
			@turns += 1
			total_points
			false
		end
	end

	def total_points
		puts "Codemaker: #{@codemaker.points} points"
		puts "Codebreaker: #{@codebreaker.points} points"
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

class Codemaker
	attr_accessor :peg1, :peg2, :peg3, :peg4, :points

	#protected

	def initialize
		@points = 0
		@peg1 = CodePeg.new(rand(6))
		@peg2 = CodePeg.new(rand(6))
		@peg3 = CodePeg.new(rand(6))
		@peg4 = CodePeg.new(rand(6))
	end

	public

	def set_code
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

class Codebreaker

	def initialize
		@points = 0
		@peg1 = ''
		@peg2 = ''
		@peg3 = ''
		@peg4 = ''
		@peg1_other = ''
		@guesses = []
		@colors = {0 => 'red', 1 => "blue", 2 => "green", 
			       3 => 'orange', 4 => "purple", 5 => "white"}
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

	def guess_computer_first
		@peg1 = CodePeg.new(rand(6))
		@peg2 = CodePeg.new(rand(6))
		@peg3 = CodePeg.new(rand(6))
		@peg4 = CodePeg.new(rand(6))
		@guesses << code_pegs
		puts " "
		all_guesses
	end	

	def guess_computer
		#p codemaker
		@peg1 = CodePeg.new(rand(6))
		@peg2 = CodePeg.new(rand(6))
		@peg3 = CodePeg.new(rand(6))
		@peg4 = CodePeg.new(rand(6))
		@guesses << code_pegs
		puts " "
		all_guesses
	end		

	def colors
		colors = {0 => 'red', 1 => "blue", 2 => "green", 3 => 'orange', 4 => "purple", 5 => "white"}
	end

	#def computer_AI_peg1
		#if @peg1.color == @codemaker.peg1.color
		#	num = @colors.select{|key, hash| hash == @peg1.color }
		#	num.keys[0]
		#else
		#	rand(6)
		#end
		#if @peg1 == @codemaker.peg1
		#	@codebreaker.code_pegs.color[0]
		#else
		#	rand(6)
		#end
	#end

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

	def add_point
		@points += 1
	end

	def points
		@points
	end
end

game_over = false
play = Board.new()

puts 'Do you want to be the "CodeBreaker" OR "CodeMaker"?'
ans = gets.chomp.to_s.downcase

while (ans != "codebreaker") && (ans != "codemaker")
	puts " "
	puts "Invalid response. Try again."
	puts 'Do you want to be the "CodeBreaker" OR "CodeMaker"?'
	ans = gets.chomp.to_s.downcase
end

if ans == "codebreaker"
	while !game_over
		play.codebreaker.guess_human
		game_over = play.check_game
	end
else ans = "codemaker"
	play.codemaker.set_code
	while !game_over
		play.codebreaker.guess_computer_first
		play.codebreaker.guess_computer		
		game_over = play.check_game
	end
end
