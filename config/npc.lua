tibia.config.npc = {
    [1] = {
        name = "Robbie",
        pos = {160, 144},
        rot = 180,
        trade = {{2, 15}, {3, 15}},
        greet = "Need stuff, %s?",
        bye = "Come again next time!",
        image = "gfx/weiwen/npc1.png"
    },
    [2] = {
        name = "Norman",
        pos = {320, 144},
        rot = 180,
        trade = {{300, 100}, {301, 200}, {302, 150}, {303, 100}, {305, 500}, {304, 850}, {306, 900}},
        greet = "What do you need?",
        bye = "See you again!",
        image = "gfx/weiwen/npc2.png"
    },
    [3] = {
        name = "Federigo",
        pos = {624, 208},
        rot = 270,
        image = "gfx/weiwen/npc3.png"
    },
    [4] = {
        name = "Francesco",
        pos = {400, 2800},
        rot = 270,
        image = "gfx/weiwen/npc3.png"
    },
    [5] = {
        name = "Frodo",
        pos = {2512, 144},
        rot = 180,
        trade = {{400, 1500}, {401, 1500}, {402, 1500}, {403, 1500}, {-400, 500}, {-401, 500}, {-402, 500}, {-403, 500}},
        greet = "Hey! Get some horses, they're supposed to be $5000 each!",
        image = "gfx/weiwen/npc5.png"
    },
    [6] = {
        name = "Heckie",
        pos = {2608, 1760},
        rot = 0,
        trade = {{200, 1000}, {201, 1000}, {207, 1000}, {208, 1000}, {203, 1000}, {210, 700}, {214, 700}, {218, 700}, {219, 700}},
        greet = "%s! Welcome!",
        bye = "Aww, don't need more furniture?",
        image = "gfx/weiwen/npc6.png"
    },
    [7] = {
        name = "Cosimo",
        pos = {2640, 448},
        rot = 270,
        image = "gfx/weiwen/npc7.png"
    },
    [8] = {
        name = "Martin",
        pos = {2640, 672},
        rot = 270,
        trade = {{-300, 40}, {-301, 80}, {-302, 60}, {-303, 40}, {-305, 200}, {-304, 350}, {-306, 400}},
        greet = "Selling stuff?",
        bye = "Come to me when you find things to sell!",
        image = "gfx/weiwen/npc8.png"
    },
    [9] = {
        name = "Enki",
        pos = {2736, 1312},
        rot = 270,
        image = "gfx/weiwen/npc3.png"
    },
    [10] = {
        name = "Vieno",
        pos = {2832, 1840},
        rot = 180,
        image = "gfx/weiwen/npc4.png"
    },
    [11] = {
        name = "Lucas",
        pos = {3632, 2416},
        rot = 180,
        image = "gfx/weiwen/npc4.png"
    },
    [12] = {
        name = "Finnbarr",
        pos = {4192, 1648},
        rot = 0,
        image = "gfx/weiwen/npc3.png"
    },
    [13] = {
        name = "Shun",
        pos = {4128, 2176},
        rot = 180,
        image = "gfx/weiwen/npc2.png"
    },
    [14] = {
        name = "Wibo",
        pos = {3536, 1200},
        rot = 180,
        image = "gfx/weiwen/npc2.png"
    },
    [15] = {
        name = "Eustachio",
        pos = {4144, 1776},
        rot = 180,
        trade = {{5, 10}},
        greet = "%s, any pizzas for you?",
        bye = "Take a seat, if you want.",
        image = "gfx/weiwen/npc8.png"
    },
    [16] = {
        name = "Demoncharm",
        pos = {2400, 3984},
        rot = 180,
        trade = {{100, 100}, {101, 100}, {103, 100}, {104, 100}, {106, 100}, {102, 30}, {105, 100}},
        greet = "Want some runes..?",
        bye = "Farewell.",
        image = "gfx/weiwen/npc4.png"
    },
    [17] = {
        name = "Barnsower",
        pos = {3120, 976},
        rot = 180,
        trade = {{100, 100}, {101, 100}, {103, 100}, {104, 100}, {106, 100}, {102, 30}, {105, 100}},
        image = "gfx/weiwen/npc3.png"
    }
}

local function contains(words, text) 
	words = words:lower(); 
	return words == text or words:find(text .. " ") or words:find(" " .. text) 
end

tibia.config.npc[3].func = function(npc, player, words, state)
	if words == "hi" then
		npc:speak("Hello! I'm looking for my brother, Francesco. Have you seen him?")
		player.tmp.npcState = {npc, 1}
	elseif contains(words, "bye") then
		npc:speak("Goodbye.")
		player.tmp.npcState = nil
	elseif state == 1 then
		if contains(words, "rest") then
			npc:speak("Would you like to rest in the inn for $10?")
			player.tmp.npcState = {npc, 2}
		elseif contains(words, "help") or contains(words, "quest") or contains(words, "mission") then
			npc:speak("I don't really need your help, but I haven't seen my brother in a long time.")
		elseif contains(words, "brother") or contains(words, "mountain") or contains(words, "francesco") then
			if player.federigoBrother then
				if player.federigoBrother == 4 then
					npc:speak("What did he say?")
					player.tmp.npcState = {npc, 3}
				elseif player.federigoBrother == 0 then
					npc:speak("Oh, I hope he's living well in the mountain.")
				else
					npc:speak("My brother went to the mountain in the south, if you find him, let him know that I'm looking for him.")
				end
			else
				npc:speak("My brother went to the mountain in the south, if you find him, let him know that I'm looking for him.")
				player.federigoBrother = 1
			end
		end
	elseif state == 2 then
		if contains(words, "yes") then
			if player:addRupee(-10) then
				player:message("You have lost $10.", sea.Color.white)
				npc:speak("Have a good rest!")
				player:setPosition(784, 240)
				player.respawnPosition = {784, 240}
				player.tmp.npcState = nil
			else
				npc:speak("Don't try to enter without paying!")
				player.tmp.npcState = nil
			end
		elseif contains(words, "no") then
			npc:speak("Alright then.")
			player.tmp.npcState = nil
		end
	elseif state == 3 then
		if contains(words, "sorry") or contains(words, "apologise") or contains(words, "apologize") then
			player:addRupee(300)
			player:message("You have recieved $300.", sea.Color.white)
			npc:speak("Really? He's apologising to me... Thank's for you help! Here's a small token of appreciation from me.")
			player.federigoBrother = 0
			player.tmp.npcState = nil
		end
	end
end

tibia.config.npc[4].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("...")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("...")
        player.tmp.npcState = nil
    elseif state == 1 then
		if player.federigoBrother then
			if contains(words, "brother") or contains(words, "federigo") then
				if player.federigoBrother == 1 or player.federigoBrother == 2 then
					npc:speak("Don't talk about him. It's dark here, I need a torch.")
					player.federigoBrother = 2
				elseif player.federigoBrother == 3 then
					npc:speak("Don't talk about him. I feel a little hungry now, can you please get me an apple?")
				elseif player.federigoBrother == 4 then
					npc:speak("Do you really want to know about my brother?")
					player.tmp.npcState = {npc, 2}
				elseif player.federigoBrother == 0 then
					npc:speak("Thanks for helping me!")
				else
					npc:speak("Yes, that's him. Can you tell him that I'm looking for him?")
				end
			elseif contains(words, "torch") then
				if player.federigoBrother == 2 then
					if player:removeItem(2) then
						npc:speak("Thank you! However, I feel a little hungry now, can you please get me an apple?")
						player.federigoBrother = 3
					else
						npc:speak("It's dark here, I need a torch.")
					end
				else
					npc:speak("It's dark here, I need a torch.")
				end
			elseif contains(words, "apple") then
				if player.federigoBrother == 3 then
					if player:removeItem(1) then
						player.federigoBrother = 4
						npc:speak("Oh thank you! Do you really want to know about my brother?")
						player.tmp.npcState = {npc, 2}
					else
						npc:speak("Mmm ... If only I could have an apple.")
					end
				end
			end
		else
			npc:speak("I have a brother, but he can't be found anywhere.")
		end
    elseif state == 2 then
        npc:speak("My brother's name is Federigo. I left town after we fell out and we never talked since. Tell him that I'm sorry, please.")
        player.tmp.npcState = nil
    end
end

tibia.config.npc[7].func = function(npc, player, words, state)
    if words == "hi" then
        if player.cheeseQuest then
            if player.cheeseQuest == 0 then
                npc:speak("Hello, there!")
            else
                npc:speak("Did you get them?")
                player.tmp.npcState = {npc, 3}
            end
        else
            npc:speak("Hello. Hey, you look like you have a lot of spare time, do you?")
            player.tmp.npcState = {npc, 1}
        end
    elseif contains(words, "bye") then
        npc:speak("Bye.")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "yes") then
            npc:speak("Oh! Then, you can do me a favour, right?")
            player.tmp.npcState = {npc, 2}
        else
            npc:speak("Nevermind, then.")
            player.tmp.npcState = nil
        end
    elseif state == 2 then
        if contains(words, "yes") then
            npc:speak("Thanks! Well, I'm currently working, but I haven't had any meals!")
            npc:speak("Can you get me 10 slices of cheese? I heard that Ratatas carry them around frequently.")
            player.cheeseQuest = 1
            player.tmp.npcState = nil
        else
            npc:speak("Nevermind, then.")
            player.tmp.npcState = nil
        end
    elseif state == 3 then
        if contains(words, "yes") then
            if player:removeItem(4, 10) then
                player:addRupee(300)
                player:message("You have received $300.", sea.Color.white)
                npc:speak("Thanks! Here's a reward, I earn much more than that anyway.")
                player.cheeseQuest = 0
                player.tmp.npcState = nil
            else
                npc:speak("I need 10 slices of cheese, now!")
                player.tmp.npcState = nil
            end
        else
            npc:speak("Well? What are you waiting for?")
            player.tmp.npcState = nil
        end
    end
end

tibia.config.npc[9].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("Welcome! Say 'rest' if you need to take a break.")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Goodbye.")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "rest") then
            npc:speak("Would you like to rest in the inn for $10?")
            player.tmp.npcState = {npc, 2}
        end
    elseif state == 2 then
        if contains(words, "yes") then
            if player:addRupee(-10) then
                player:message("You have lost $10.", sea.Color.white)
                npc:speak("Have a good rest!")
                player:setPosition(2704, 1040)
                player.respawnPosition = {2704, 1040}
                player.tmp.npcState = nil
            else
                npc:speak("Don't try to enter without paying!")
                player.tmp.npcState = nil
            end
        elseif contains(words, "no") then
            npc:speak("Alright then.")
            player.tmp.npcState = nil
        end
    end
end

tibia.config.npc[10].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("Hello! Would you like to go to the new island for $10?")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Goodbye.")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "yes") then
            if player:addRupee(-10) then
                player:message("You have lost $10.", sea.Color.white)
                npc:speak("Bon voyage!")
                player:setPosition(3632, 2448)
                player.tmp.npcState = nil
            else
                npc:speak("Don't try to enter without paying!")
                player.tmp.npcState = nil
            end
        elseif contains(words, "no") then
            npc:speak("Alright then.")
            player.tmp.npcState = nil
        end
    end
end

tibia.config.npc[11].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("Hello! Would you like to go to the old island for $10?")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Goodbye.")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "yes") then
            if player:addRupee(-10) then
                player:message("You have lost $10.", sea.Color.white)
                npc:speak("Bon voyage!")
                player:setPosition(2832, 1872)
                player.tmp.npcState = nil
            else
                npc:speak("Don't try to enter without paying!")
                player.tmp.npcState = nil
            end
        elseif contains(words, "no") then
            npc:speak("Alright then.")
            player.tmp.npcState = nil
        end
    end
end

tibia.config.npc[12].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("Welcome! Say 'rest' if you need to take a break.")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Goodbye.")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "rest") then
            npc:speak("Would you like to rest in the inn for $10?")
            player.tmp.npcState = {npc, 2}
        end
    elseif state == 2 then
        if contains(words, "yes") then
            if player:addRupee(-10) then
                player:message("You have lost $10.", sea.Color.white)
                npc:speak("Have a good rest!")
                player:setPosition(4048, 1584)
                player.respawnPosition = {4048, 1584}
                player.tmp.npcState = nil
            else
                npc:speak("Don't try to enter without paying!")
                player.tmp.npcState = nil
            end
        elseif contains(words, "no") then
            npc:speak("Alright then.")
            player.tmp.npcState = nil
        end
    end
end

tibia.config.npc[13].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("Care for a gamble? I'll roll a dice and if you get what you chose, you'll win 6 fold.")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Oh, you don't want to win?")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "yes") or contains(words, "gamble") or contains(words, "bet") then
            npc:speak("How much do you want to bet?")
            player.tmp.npcState = {npc, 2}
        elseif contains(words, "no") then
            npc:speak("Oh, you don't want to win?")
            player.tmp.npcState = nil
        elseif contains(words, "earning") or contains(words, "rupee") then
            npc:speak("I have $"..sea.game.npc13.." currently.")
        end
    elseif state == 2 then
        local bet = tonumber(words)
        if bet and bet >= 1 then
            bet = math.floor(bet)
            if player:addRupee(-bet) then
                sea.game.npc13 = sea.game.npc13 + bet
                player:message("You have lost $" .. bet .. ".", sea.Color.white)
                player.tmp.dice = bet
                npc:speak("You'll win $" .. bet * 6 .. " if you pick the correct number! Pick a number from 1-6!")
                player.tmp.npcState = {npc, 3}
            else
                npc:speak("You don't have that much rupee!")
                player.tmp.npcState = {npc, 1}
            end
        else
            npc:speak("You can't bet that!")
            player.tmp.npcState = {npc, 1}
        end
    elseif state == 3 then
        local number = tonumber(words)
        if number and number >= 1 and number <= 6 then
            local random = math.random(6)
            if random == number then
                local earning = player.tmp.dice * 6
                player:addRupee(earning)
                sea.game.npc13 = sea.game.npc13 - earning
                player:message("You have received $" .. earning .. ".", sea.Color.white)
                npc:speak("You rolled a " .. random .. ". You won! Here's $" .. earning .. " as the prize.")
            else
                npc:speak("You rolled a " .. random .. ". You lost. How about trying again?")
            end
            player.tmp.npcState = {npc, 1}
            player.tmp.dice = nil
        else
            npc:speak("Pick a number from 1-6!")
        end
    end
end

tibia.config.npc[14].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("The toll is $10. Do you want to cross this bridge?")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Not crossing?")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "yes") then
            if player:addRupee(-10) then
                player:message("You have lost $10.", sea.Color.white)
                player:setPosition(3536, 1264)
            else
                npc:speak("No rupee, no crossing.")
            end
        elseif contains(words, "no") then
            npc:speak("Not crossing?")
        end
        player.tmp.npcState = nil
    end
end

tibia.config.npc[17].func = function(npc, player, words, state)
    if words == "hi" then
        npc:speak("Hey! Do you want to enter the PVP zone? You need to have at least $100 so you can drop them when you die!")
        player.tmp.npcState = {npc, 1}
    elseif contains(words, "bye") then
        npc:speak("Goodbye!")
        player.tmp.npcState = nil
    elseif state == 1 then
        if contains(words, "yes") then
            if player.rupee >= 100 then
                player:setPosition(3056, 1040)
                npc:speak("Good luck in the PVP zone!")
            else
                npc:speak("Aww... You don't even have $100!")
            end
        elseif contains(words, "no") then
            npc:speak("Okay! Come back when you want!")
        end
        player.tmp.npcState = nil
    end
end