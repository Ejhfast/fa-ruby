require 'fa.rb'

prison_payoff = Hash.new(Hash.new(nil))
prison_payoff["C"]["C"] = [3,3]
prison_payoff["C"]["D"] = [0,5]
prison_payoff["D"]["C"] = [5,0]
prison_payoff["D"]["D"] = [1,1]

def play_game a1, a2, numgames, payoff
	goes_first = rand 2
	order = []
	if goes_first == 0
		start = a1
		follow = a2
		order = ["a1","a2"]
	else
		start = a2
		follow = a1
		order = ["a2","a1"]
	end
	start_score = 0
	follow_score = 0
	start_move = run_automata start, []
	puts "Game play"
	(0..numgames).each do |game|
		follow_move = run_automata follow, [start_move]
		puts "\tStarter: #{start_move} Follower: #{follow_move}"
		res = payoff[start_move][follow_move]
		puts "\t\tPayoff: #{res}"
		start_score = start_score + res[0]
		follow_score = follow_score + res[1]
		start_move = run_automata start, [follow_move]
	end
	puts "For order #{order}"
	puts "Starter: #{start_score}"
	puts "Follower: #{follow_score}"
end

p1 = build_random_automata ["C","D"], 3, ["C","D"]
p2 = build_random_automata ["C","D"], 3, ["C","D"]
puts "p1:"
pp p1
puts "p2:"
pp p2
#play_game p1, p2, 20, prison_payoff
pp prison_payoff
