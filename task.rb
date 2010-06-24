require 'fa.rb'

def xor auto
	score = 0
	cases =[ [[0,0],0], [[0,1],1], [[1,0],1], [[1,1],0]]
	cases.each do |c|
		res = run_automata auto, c[0]
		if res == c[1]
			score = score + 1
		end
	end
	score
end


def sumlist auto
	listmax = 5
	probs = (1..30).map{|x| (0..(rand listmax)).map{|y| rand 10}}.to_a
	answrs = probs.map{|x| 
		sum = x.inject{|sum,x| sum ? sum+x : x}
		sum.to_s[sum.to_s.size-1].to_i}.to_a
	score = 0
	probs.each_index do |c|	
		res = run_automata auto, probs[c]
		if res == answrs[c]
			score = score + 1
		end
	end
	score
end

def is_even x
	listmax = 5
	probs = (1..50).map{|x| (0..(rand listmax)).map{|y| rand 10}}
	answrs = probs.map{|x| x.join.to_i % 2 == 0}
	
end


def tourney_select pop_list
		c1 = rand pop_list.size
		c2 = rand pop_list.size
		if pop_list[c1][1] > pop_list[c2][1]
			Marshal.load(Marshal.dump(pop_list[c1][0]))
		else
			Marshal.load(Marshal.dump(pop_list[c2][0]))
		end
end

def avg pop_fits
	sum = pop_fits.inject{|sum,x| sum ? sum+x : x}
	avg = sum.to_f / pop_fits.size.to_f
end

maxsize = 20
autolang = 20
values = (0..10).to_a
maxgen = 1000
mut_rate = 50
maxfit = 30
gensize=100
puts "States allowed: #{maxsize}"
puts "Over lang: #{autolang}"
puts "On Values: #{values}"
puts "Max Fit: #{maxfit}"
puts "Gensize: #{gensize}"
puts "MutRate: #{mut_rate}"

listmax = 10
numcases = 30
#pp probs
#pp answrs
continue = true
gen = 0
pop = (1..gensize).map{|x| build_random_automata autolang, maxsize, values}
while (gen < maxgen) && continue
	puts "Generation #{gen}:"
	pop = pop.map{|x| [x,(sumlist x)]}
	av = avg pop.map{|x| x[1]}
	bst = pop.sort_by{|x| x[1]}.last
	puts "\tAverage Fitness: #{av}"
	puts "\tBest Fitness #{bst[1]}"
	if bst[1] >= maxfit
		puts "\tFound maxima"
		pp bst[0]
		continue = false
		break
	end		
	new_pop = (1..(gensize/2)).map{|x| tourney_select pop} + (2..(gensize/2)).map{|x| build_random_automata autolang, maxsize, values}
	new_pop = new_pop.map{|x| [x,(sumlist x)]}
	av2 = avg new_pop.map{|x| x[1]}
	puts "\tAverage Fitness of Selected: #{av2}"
	new_pop = new_pop.map{|x| 
		if (rand 100) <= mut_rate
			(mutate_automata x[0], autolang, maxsize, values)
		else
			x[0]
		end}
	new_pop.push(bst[0])
	pop = new_pop
	gen = gen + 1
end
#a = (build_random_automata 4, 4, [0,1])
#pp a
#puts (xor a)
