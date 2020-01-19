defmodule Assign2 do
  
defp suit_search(number) do
        String.last(number)
end 

defp suit_create(ch, list) do
	Enum.map(list, fn x -> if (suit_search(x) == ch) do String.to_integer(String.slice(x,0, String.length(x)-1)) end end) 
	|> Enum.filter(&!is_nil(&1)) 
	|> Enum.sort(&(&1) >= (&2))
	 
end


defp suit_write(list) do
	list = to_string(Enum.map(list, fn x -> to_string(x) <> " "  end)) 
	String.trim_trailing(list)

end

defp hand_eval(suit) do 
	#accumulates points from face cards 
	a = Enum.reduce(suit, 0, fn(x, acc)  -> 
		if ((x) > 10) do
		 (x) - 10 + acc 
		else 
		 acc + 0
		end
	end) 

	#adds points for singleton/doubleton/void 
	a = case Enum.count(suit) do
		0 -> a + 3
		1 -> a + 2
		2 -> a + 1
		_-> a + 0
	end 
	
end
 
defp is_no_trump(suit) do
     cond do
	Enum.count(suit) <= 1 -> false
	List.first(suit) < 11 -> false
	List.first(suit) == 14 || List.first(suit) == 13 -> true
	List.first(suit) == 12 && Enum.count(suit) >= 3 -> true
	List.first(suit) == 11 && Enum.count(suit) >= 4 -> true
	true -> false 
	end
end

defp is_no_trump_all(hand) do
	is_nt = Enum.map(hand, fn {_, v} -> is_no_trump(v) end) 
	if Enum.any?(is_nt, fn x -> x == false end) do
		false
	else
		true
	end
end


defp suit_to_index(suit) do
	case suit do
		"s" -> 0 #Pass
		"C" -> 1
		"D" -> 2
		"H" -> 3
		"S" -> 4
		"N" -> 5
	end
end

def format(list) do
	#deal cards      
	west = Enum.take_every(list, 4)
	
	list = tl list
	north = Enum.take_every(list, 4)
        
	list = tl list
	east = Enum.take_every(list, 4)
	
	list = tl list
	south = Enum.take_every(list,4) 

	#separate into lists for each suit 	
	north_spade = suit_create("S", north); north_heart = suit_create("H", north)
	north_diam = suit_create("D", north); north_club = suit_create("C", north) 	 	
	
	south_spade = suit_create("S", south); south_heart = suit_create("H", south)
	south_diam = suit_create("D", south); south_club = suit_create("C", south)
	
	west_spade = suit_create("S", west); west_heart = suit_create("H", west)
	west_diam = suit_create("D", west); west_club = suit_create("C", west) 
	
	east_spade = suit_create("S", east); east_heart = suit_create("H", east)
	east_diam = suit_create("D", east); east_club = suit_create("C", east) 

	#combine hands into map
	north_map = %{"S" => north_spade, "H" => north_heart, "D" => north_diam, "C" => north_club} 
	south_map = %{"S" => south_spade, "H" => south_heart, "D" => south_diam, "C" => south_club} 
	east_map = %{"S" => east_spade, "H" => east_heart, "D" => east_diam, "C" => east_club}
	west_map = %{"S" => west_spade, "H" => west_heart, "D" => west_diam, "C" => west_club}
	card_list = [south_map, west_map, north_map, east_map] 

	west_length = Enum.map(west_map, fn {_,v} -> Enum.count(v) end) |> Enum.max()
	north_length = Enum.map(north_map, fn {_,v} -> Enum.count(v) end) |> Enum.max()
	south_length = Enum.map(south_map, fn {_,v} -> Enum.count(v) end) |> Enum.max()
	west_len = west_length*2+2 
	ns_len = cond do
		north_length >= south_length -> north_length*2+3
		true -> south_length*2+2
		end

	#Go through max. 12 rounds of bidding
	bid_list = for n <- 0..11, do: "Pass"
	
	bid_list = check_bid(bid_list, 0, card_list)
	bid_list = check_bid(bid_list, 1, card_list)
	bid_list = check_bid(bid_list, 2, card_list)
	bid_list = check_bid(bid_list, 3, card_list) 
	bid_list = check_bid(bid_list, 4, card_list)
        bid_list = check_bid(bid_list, 5, card_list)
        bid_list = check_bid(bid_list, 6, card_list) 
        bid_list = check_bid(bid_list, 7, card_list)  
        bid_list = check_bid(bid_list, 8, card_list)
        bid_list = check_bid(bid_list, 9, card_list)
        bid_list = check_bid(bid_list, 10, card_list)
        bid_list = check_bid(bid_list, 11, card_list)

	declarer = get_declarer(bid_list)  

	#Takes away extra passes 
	last_bid = bid_info(bid_list) |> List.first() 
	last_bid_index = Enum.find_index(bid_list, &(&1 == last_bid))
	bid_list_length = length(bid_list)-1
	bid_list = if (last_bid_index+3 < bid_list_length) do
		 Enum.slice(bid_list, 0, last_bid_index+4) 
	else
		bid_list
	end
	
	bid_list = Enum.map(bid_list, fn x -> if String.last(x) == "N" do
			 x<>"T"
		else
			x
		 end end) 
	
	round_one = Enum.split(bid_list, 4)
	bid_list = elem(round_one, 1) 
	round_one = elem(round_one, 0) 
       	round_one = bid_spaces(round_one) |> to_string() |> String.trim_trailing()  			 

	round_two = Enum.split(bid_list, 4) 
	bid_list = elem(round_two, 1) 
	round_two = elem(round_two, 0) 
	round_two = bid_spaces(round_two) |> to_string() |> String.trim_trailing()	
        
	round_three = Enum.split(bid_list, 4) 
	bid_list = elem(round_three, 1)
	round_three = elem(round_three, 0)  
	round_three = bid_spaces(round_three) |> to_string() |> String.trim_trailing()
	
	#format string
	list = ("North" |> String.pad_leading(west_len+5)) 
		<> "\n" <> ("S " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(north_spade))
		<> "\n" <> ("H " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(north_heart))
		<> "\n" <> ("D " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(north_diam))
		<> "\n" <> ("C " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(north_club))
	<> ("\nWest" |> String.pad_trailing(west_len+ns_len)) <> "East\nS "  
		<> (suit_write(map_letters(west_spade)) |> String.pad_trailing(west_len+ns_len-3)) <> "S " <> suit_write(map_letters(east_spade))
		<> "\nH " <> (suit_write(map_letters(west_heart)) |> String.pad_trailing(west_len+ns_len-3)) <> "H " <> suit_write(map_letters(east_heart)) 
		<> "\nD " <> (suit_write(map_letters(west_diam)) |> String.pad_trailing(west_len+ns_len-3)) <> "D " <> suit_write(map_letters(east_diam))
		<> "\nC " <> (suit_write(map_letters(west_club)) |> String.pad_trailing(west_len+ns_len-3)) <> "C " <> suit_write(map_letters(east_club))   
	<> "\n" <>("South" |> String.pad_leading(west_len+5)) 
		<> "\n" <> ("S " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(south_spade))  
		<> "\n" <> ("H " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(south_heart))
		<> "\n" <> ("D " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(south_diam))
		<> "\n" <> ("C " |> String.pad_leading(west_len+2)) <> suit_write(map_letters(south_club))
	<> "\n"
	<> "   South West North East\n"
	<> "   "<> round_one <> "\n" 
	<> "   "<> round_two <> "\n" 
	<> "   "<> round_three <> "\n"   
	<> "   Declarer: " <> declarer <> "\n" 
end

defp map_letters(hand) do
	hand = Enum.map(hand, fn v -> case v do
				11 -> "J"
				12 -> "Q"
				13 -> "K"
				14 -> "A"
				_ -> v
			end end) 
end

defp bid_spaces(bid_list) do
	bid_ind = Enum.with_index(bid_list) 
	for {n, m} <- bid_ind do
		suit = String.slice(n,1, String.length(n)-1)
		cond do
			n == "Pass" && rem(m,2) != 0 -> "Pass " #East or West
			n == "Pass" && rem(m,2) == 0 -> "Pass  " #North or South
			suit == "NT" && rem(m,2) != 0 -> to_string(n) <> "  "
			suit == "NT" && rem(m,2) == 0 -> to_string(n) <> "   " 
			rem(m,2) != 0 -> to_string(n) <> "   "
			rem(m,2) == 0 -> to_string(n) <> "    "
		end
	end
end

defp get_declarer(bid_list) do
	last_bid = bid_info(bid_list) |> List.first() 
	fin_index = Enum.find_index(bid_list, &(&1 == last_bid))
	last_suit = String.last(last_bid) 
	team_one = team_bids(bid_list, 1)
	team_two = team_bids(bid_list, 2) 
        team_list = cond do
               rem(fin_index, 2) == 0 -> team_one
               rem(fin_index, 2) != 0 -> team_two
        end
	teammates = cond do 
		rem(fin_index, 2) == 0 -> ["South","North"]
                rem(fin_index, 2) != 0 -> ["West","East"] 
        end

	bid_index = Enum.find_index(team_list, &(String.last(&1) == last_suit))	
	cond do
	last_bid == "Pass" -> "None"
        bid_index == 0 || bid_index == 2 || bid_index == 4 -> List.first(teammates) 
        bid_index == 1 || bid_index == 3 || bid_index == 5 -> List.last(teammates)
	end

end

defp team_bids(list, team) do
	tail = tl list
	case team do
	1 -> [hd list] ++ Enum.map_every(tail, 2, &(&1 = nil)) |> Enum.filter(&(&1 != nil)) 
	2 -> Enum.map_every(list, 2, &(&1 = nil)) |> Enum.filter(&(&1 != nil)) 
	end
end

defp opening_suit(hand) do
	max_suit = Enum.map(hand, fn {k,v} -> {k, Enum.count(v)} end) |> Enum.reverse() |> Enum.max_by(fn {k, v} -> v end)
	
	club_points = hand_eval(hand["C"])
	club_length = Enum.count(hand["C"])
	diamond_points = hand_eval(hand["D"])
	diamond_length = Enum.count(hand["D"])

	cond do
		elem(max_suit,1) >= 5 -> elem(max_suit,0)  	
		club_length > diamond_length -> "C"
		diamond_length > club_length -> "D" 
		club_points > diamond_points -> "C"
		diamond_points > club_points -> "D"
		true -> "C"
	end
end

defp opening_suit_nt(hand) do
        if is_no_trump_all(hand) == true do
                "N"
        else
                opening_suit(hand)
        end
end

defp check_bid(bid_list, bid_index, card_list) do
	hand = get_hand(card_list, bid_index) |> List.first()  	
	indexed_hand = get_hand(card_list, bid_index)
	team_one = team_bids(bid_list, 1)
	team_two = team_bids(bid_list, 2)
	team_list = cond do
		rem(bid_index, 2) == 0 -> team_one
		rem(bid_index, 2) != 0 -> team_two
	end
	point_list = for n <- ["C","D","H","S"], do: hand_eval(hand[n])
	points = Enum.reduce(point_list, fn x, acc -> x+acc end)   

	num_of_bids = bid_info(team_list) |> List.last()
	bid_list = cond do
		num_of_bids == 0 -> cond do 
			points >= 16 -> List.replace_at(bid_list, bid_index, to_string(opening_num(bid_list,opening_suit_nt(hand)))<>opening_suit_nt(hand))
			points >= 13 -> List.replace_at(bid_list, bid_index, to_string(opening_num(bid_list,opening_suit(hand)))<>opening_suit(hand)) 
			true -> List.replace_at(bid_list, bid_index, "Pass") 
			end 
		num_of_bids == 1 -> List.replace_at(bid_list, bid_index, answer(indexed_hand, points, team_list, bid_index, bid_list)) 
		num_of_bids == 2 -> List.replace_at(bid_list, bid_index, final_bid(points, team_list, card_list, bid_index, bid_list))  
		true -> List.replace_at(bid_list, bid_index, "Pass") 
	end 
	
end

defp final_bid(points, team_list, card_list, bid_index, bid_list) do
	teammate_index = cond do
		bid_index >= 10 -> bid_index-2
		bid_index <= 9 -> bid_index+2
	end
	teammate_hand = get_hand(card_list, teammate_index) |> List.first() 
        teammate_suit = longest_suit_nt(teammate_hand)
        player_hand = get_hand(card_list, bid_index) |> List.first()
	player_suit = longest_suit_nt(player_hand) 
	teammate_point_list = for n <- ["C","D","H","S"], do: hand_eval(teammate_hand[n])  
	teammate_points = Enum.reduce(teammate_point_list, fn x, acc -> x+acc end) 

	teammate_points = cond do
		teammate_points >= 13 -> 13
		teammate_points >= 10 -> 10
		teammate_points >= 8 -> 8
		teammate_points >= 6 -> 6
		true -> 0
	end

	partner_bid = if bid_index >= 2, do: Enum.fetch!(bid_list, bid_index-2)
	player_suit_lengths = Enum.map(player_hand, fn {_,v} -> Enum.count(v) end)
        partner_suit_index = partner_info(partner_bid) |> List.last()
        player_max = case partner_suit_index do
                                4 -> 0 #ignore if no trump
                                99 -> 0 #ignore if partner hasn't bid 
                                _ -> Enum.at(player_suit_lengths, partner_suit_index) #finds length of player's suit at partner's bid suit
                              end

	total_points = points + teammate_points

        last_bid = bid_info(bid_list) |> List.first()

	bid = cond do
	total_points >= 36 && too_low(last_bid,"7"<>player_suit) == false -> "7"<>player_suit 
	total_points >= 32 && too_low(last_bid,"6"<>player_suit) == false -> "6"<>player_suit
	
	total_points >= 29 && is_suit?(player_suit, "D") == true && too_low(last_bid,"5"<>player_suit) == false -> "5"<>player_suit 
	total_points >= 29 && is_suit?(player_suit, "C") == true && too_low(last_bid,"5"<>player_suit) == false -> "5"<>player_suit 
	total_points >= 29 && is_suit?(teammate_suit, "D") == true && player_max >= 4 && too_low(last_bid,"5"<>teammate_suit) == false -> "5"<>teammate_suit 
	total_points >= 29 && is_suit?(teammate_suit, "C") == true && player_max >= 4 && too_low(last_bid,"5"<>teammate_suit) == false -> "5"<>teammate_suit 
	
	total_points >= 27 && is_suit?(player_suit, "S") == true && too_low(last_bid,"4"<>player_suit) == false -> "4"<>player_suit 
        total_points >= 27 && is_suit?(player_suit, "H") == true && too_low(last_bid,"4"<>player_suit) == false -> "4"<>player_suit 
        total_points >= 27 && is_suit?(teammate_suit, "S") == true && player_max >= 4 && too_low(last_bid,"4"<>teammate_suit) == false -> "4"<>teammate_suit
        total_points >= 27 && is_suit?(teammate_suit, "H") == true && player_max >= 4 && too_low(last_bid,"4"<>teammate_suit) == false -> "4"<>teammate_suit
	
	total_points >= 25 && no_trump?(player_suit, teammate_suit) == true && too_low(last_bid,"3N") == false -> "3N"
	true -> "Pass" 
	end

end

defp too_low(last_bid, bid) do
	if bid_weight(last_bid) >= bid_weight(bid) do
		true
	else
		false
	end
end

defp no_trump?(suit1, suit2) do
	if suit1 == "N" || suit2 == "N" do
		true
	else
		false
	end

end

defp is_suit?(best_suit, char) do
	if best_suit == char do
		true
	else
		false
	end
end

defp opening_num(bid_list, plr_suit) do
	last_suit = bid_info(bid_list) |> List.first() |> String.last()
	if suit_to_index(plr_suit) <= suit_to_index(last_suit) do
		2
	else
		1
	end

end

defp get_hand(card_list, bid_index) do
      cond do
        bid_index == 0 || bid_index == 4 || bid_index == 8 -> [Enum.at(card_list, 0), 0]
        bid_index == 1 || bid_index == 5 || bid_index == 9 -> [Enum.at(card_list, 1), 1]
        bid_index == 2 || bid_index == 6 || bid_index == 10 -> [Enum.at(card_list, 2), 2]
        bid_index == 3 || bid_index == 7 || bid_index == 11 -> [Enum.at(card_list, 3), 3]
      end #returns [hand, player index] 
end

defp bid_info(bid_list) do
	last_bid = Enum.reverse(bid_list) |> Enum.find("Pass", &(&1 != "Pass"))
        num_of_bids = Enum.filter(bid_list, fn x -> x != "Pass" end) |> length
	[last_bid, num_of_bids] 
end

defp longest_suit(hand) do
        max_suit = Enum.map(hand, fn {k,v} -> {k, Enum.count(v)} end) |> Enum.reverse() |> Enum.max_by(fn {k, v} -> v end)
	elem(max_suit, 0) 
end

defp longest_suit_nt(hand) do      
        if is_no_trump_all(hand) == true do
                "N"
        else
                longest_suit(hand) 
        end
end

defp answer(indexed_hand, points, team_list, bid_list_index, bid_list) do
	hand = indexed_hand |> List.first()
	player_index = indexed_hand |> List.last()
	player_suit_lengths = Enum.map(hand, fn {_,v} -> Enum.count(v) end)

	partner_index = case player_index do
		0 -> 2
		1 -> 3
		2 -> 0
		3 -> 1
	end
	
	partner_bid = if bid_list_index >= 2, do: Enum.fetch!(bid_list, bid_list_index-2)   
	


	answer_suit = cond do
		points >= 13 -> suit_13_points(player_suit_lengths, partner_bid, hand) 
                points >= 10 -> longest_suit(hand) 
                points >= 8 -> longest_suit(hand) 
                points >= 6 -> suit_6_points(player_suit_lengths, partner_bid, hand)
                true -> "Pass"
        end

	bid = cond do
		points >= 13 && answer_suit != "Pass" -> bid_plus_one("1"<>answer_suit, bid_list) 
		points >= 10 && answer_suit != "Pass" -> min_bid("1"<>answer_suit, bid_list) 
		points >= 8 && answer_suit != "Pass" && same_level?("1"<>answer_suit, bid_list) == true -> min_bid("1"<>answer_suit, bid_list) 
		points >= 6 && answer_suit != "Pass" -> min_bid("1"<>answer_suit, bid_list) 
		true -> "Pass"
	end

end

defp suit_13_points(player_suit_lengths, partner_bid, hand) do
	partner_suit = partner_info(partner_bid) |> List.first()
	partner_suit_index = partner_info(partner_bid) |> List.last() 

	player_max = case partner_suit_index do
				4 -> 0 #if no trump, longest_suit/1 will handle it
				99 -> 0 #occurs when partner bid is a pass, ignore it   							 
				_ -> Enum.at(player_suit_lengths, partner_suit_index) #finds length of suit at partner's bid suit 
	  		      end

        cond do
                player_max >= 3 -> partner_suit
                true -> longest_suit_nt(hand) #this also checks if no trump hand 
        end
end

defp partner_info(partner_bid) do
	partner_suit = String.at(partner_bid, String.length(partner_bid)-1) 
	partner_suit_index = case partner_suit do
				"C" -> 0
				"D" -> 1
				"H" -> 2
				"S" -> 3 
				"N" -> 4
				  _ -> 99 
		              end

	if partner_bid != "Pass" do
	[partner_suit, partner_suit_index] 
	else
	["X", 99] 
	end
end

defp suit_6_points(player_suit_lengths, partner_bid, hand) do
        partner_suit = partner_info(partner_bid) |> List.first()
        partner_suit_index = partner_info(partner_bid) |> List.last()

        player_max = case partner_suit_index do
                                4 -> 0 
                                99 -> 0 
                                _ -> Enum.at(player_suit_lengths, partner_suit_index) 
                              end

        cond do
                player_max >= 3 -> partner_suit
                true -> "Pass"
        end
end

defp bid_weight(bid) do
        weights = ["1C","1D","1H","1S","1N","2C","2D","2H","2S","2N","3C","3D","3H","3S","3N","4C","4D","4H","4S","4N","5C","5D","5H","5S","5N","6C","6D","6H","6S","6N","7C","7D","7H","7S","7N"]
        Enum.find_index(weights, fn x -> x == bid end)
end

defp bid_from_weight(num) do 
        weights = ["1C","1D","1H","1S","1N","2C","2D","2H","2S","2N","3C","3D","3H","3S","3N","4C","4D","4H","4S","4N","5C","5D","5H","5S","5N","6C","6D","6H","6S","6N","7C","7D","7H","7S","7N"]
        Enum.fetch!(weights, num)
end

defp bid_plus_one(bid_new, bid_list) do
	last_bid = bid_info(bid_list) |> List.first() 
        new_weight = bid_weight(bid_new)
        prev_weight = bid_weight(last_bid)
        diff = prev_weight - new_weight
	new_weight = cond do
                diff <= -6 -> new_weight
                diff < 0 -> new_weight + 5
                diff <= 4 -> new_weight + 10
                diff <= 9 -> new_weight + 15
                diff <= 14 -> new_weight + 20
                diff <= 19 -> new_weight + 25
                diff <= 24 -> new_weight + 30
                diff <= 29 -> new_weight + 30
		true -> 99
         end

	if new_weight == 99 do
		"Pass"
	else
        	bid_from_weight(new_weight)
	end
end

defp same_level?(bid_new, bid_list) do
        new_bid = min_bid(bid_new, bid_list)
	new_num = String.slice(new_bid, 0, String.length(new_bid)-1) 
	old_bid = bid_info(bid_list) |> List.first()
	old_num = String.slice(old_bid, 0, String.length(old_bid)-1) 
        if old_num != new_num do
                false
        else
                true
        end
end

defp min_bid(bid_new, bid_list) do
	last_bid = bid_info(bid_list) |> List.first() 
        new_weight = bid_weight(bid_new)
        prev_weight = bid_weight(last_bid)

        diff = prev_weight - new_weight
        new_weight = cond do
                diff < 0 -> new_weight
                diff <= 4 -> new_weight + 5
                diff <= 9 -> new_weight + 10
                diff <= 14 -> new_weight + 15
		diff <= 19 -> new_weight + 20
		diff <= 24 -> new_weight + 25
		diff <= 29 -> new_weight + 30
		true -> 99 
        end

	if new_weight == 99 do
                "Pass"
        else
                bid_from_weight(new_weight)
        end
end

def withPermutation(list) do
	for n <- list do 
		cond do
		n < 13 -> to_string(rem(n, 13)+1) <> "C" 
		n == 13 -> "14C" 
		n < 26 -> to_string(rem(n, 13)+1) <> "D"
		n == 26 -> "14D"
		n < 39 -> to_string(rem(n, 13)+1) <> "H"
		n == 39 -> "14H"
		n < 52 -> to_string(rem(n, 13)+1) <> "S"
		n == 52 -> "14S" 
		end	
	end
end	



end
