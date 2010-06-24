require 'pp'

def build_random_automata over_lang, max_states, values
	state_num = (rand max_states) 
	(0..state_num).map{|cur_state|
		value = values[(rand values.size)]
		num_edges = over_lang.map{|x| if (rand 2) == 1 ; x ; else ; nil end}.compact
		# +1 bwlow, as rand 0 -> 0.001 to .99
		[value,num_edges.map{|x| [x, (rand (state_num+1))] }]
	}
end

def display_automata auto
	auto.each_index do |state|
		puts "State #{state} with value #{auto[state][0]}"
		auto[state][1].each_index do |edge|
			e = auto[state][1][edge]
			puts "\tEdge #{edge} connecting on #{e[0]} to state #{e[1]}"
		end
	end
end

def run_automata auto, arr
	state = 0
	value = auto[state][0]
	arr.each do |curr|
		begin
			potential_edges = auto[state][1]
			selected_edge = potential_edges.select{|x| x[0] == curr}[0]
			if selected_edge == nil
				next_state = state
				next_value = value
			else
				next_state = selected_edge[1]
				next_value = auto[next_state][0]
			end
		rescue
		end
			state = next_state
			value = next_value
	end
	#puts "End in state #{state} with value #{value}"
	value
end

def mutate_automata auto, over_lang, max_states, values
	# Do we want to insert a state, delete a state, or change
	# an existing state?
	#puts "Mutating the automata"
	if auto.size >= max_states
		options = 2
	else
		options = 3
	end
	choice = rand options
	if choice == 0 # Change existing
		select_state = rand auto.size
		#puts "Changing existing state/transistion: on state #{select_state}"
		v_or_e = rand 2
		if v_or_e == 0 # Change value
			#puts "\tChanging a state value"
			new_v = values.sort_by{|x| (rand)}[0]
			if values.size != 1
				while new_v == auto[select_state][0]
					new_v = values.sort_by{|x| (rand)}[0]
				end
			end
			auto[select_state][0] = new_v
		else #change an edge
			#puts "\tChanging a state transition"
			edges = auto[select_state][1]
			if edges.size == 0
				puts "\t\tTrying again"
				mutate_automata auto, over_lang, max_states, values # Cannot make a change, try again
			else
				pick_edge = rand edges.size
				#puts "\tChanging transition #{pick_edge}"
				s_or_t = rand 2
				if s_or_t == 0 # change transition value
					#puts "\t\tChanging the label for transistion"
					picked_tran_v = edges[pick_edge][0]
					cannot_use = edges.map{|x| x[0]}
					not_finished = true
					change_to = 0
					if edges.size != over_lang.size 
						possible = over_lang
						doable = possible - cannot_use
						change_to = doable.sort_by{|x| (rand)}[0]
						auto[select_state][1][pick_edge][0] = change_to
					else
						#puts "\t\t\tTry again"
						mutate_automata auto, over_lang, max_states, values
					end
				elsif s_or_t == 1 # change transition state
					#puts "\t\tChanging transition destination"
					des = auto[select_state][1][pick_edge][1]
					if auto.size == 1
						mutate_automata auto, over_lang, max_states, values
					elsif des == auto.size
						new_s_val = des - 1
					else
						new_s_val = des + 1
					end
					auto[select_state][1][pick_edge][1] = new_s_val	
				end
			end
		end
	elsif choice == 1 # delete a state
		if auto.size == 1
			#puts "\tToo small, try again"
			mutate_automata auto, over_lang, max_states, values
		else
			existing = auto.size
			picked_state = rand existing
			#puts "\tdeleting a state: #{picked_state}"
			auto.delete_at(picked_state)
			# delete transitions to old state
			auto.map{|a| a[1].select{|x| x[1] != picked_state}} 
		end
	else # insert a state
		#puts "\tinserting a state"
		buto = (build_random_automata over_lang, 0, values)
		buto[0][1] = buto[0][1].map{|x| [x[0],(rand (auto.size + 1))]}
		auto = auto + buto
	end
	auto
end
					 

#a = (build_random_automata 12, 12, (0..10).to_a)
#(0..100).each do |x| 
#	puts (run_automata a, [1,2,3,4,5,6,7,11])
#end
#pp a
#display_automata a
#test = [1,1,2,3]
#puts "Evaluating a on #{test}"
#run_automata a, test
#puts "Mutating a:"
#a = mutate_automata a, 4, 4, ["T","F"]
#pp a
#display_automata a
#(0..1000).each do
#	puts "Next:\n"
#	a = (build_random_automata ["C","D"], 4, ["C","D"])
#	pp a
#	puts (run_automata a, ["C","C","D","C"])
#	a = mutate_automata a, ["D","C"], 4, ["C","D"]
#	pp a
#	puts (run_automata a, ["C","C","D","C"])
#end
