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

tibia.config.npc[3].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Greetings! Say 'rest' if you need to take a break.")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Goodbye.")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "rest") then
			NPCspeak(npc, "Would you like to rest in the inn for $10?")
			PLAYERS[id].tmp.npcstate = {npc, 2}
		elseif contains(words, "help") or contains(words, "quest") or contains(words, "mission") then
			NPCspeak(npc, "I don't really need your help, but I haven't seen my brother in a long time.")
		elseif contains(words, "brother") or contains(words, "mountain") or contains(words, "francesco") then
			if PLAYERS[id].FederigoBrother then
				if PLAYERS[id].FederigoBrother == 4 then
					NPCspeak(npc, "What did he say?")
					PLAYERS[id].tmp.npcstate = {npc, 3}
				elseif PLAYERS[id].FederigoBrother == 0 then
					NPCspeak(npc, "Oh, I hope he's living well in the mountain.")
				else
					NPCspeak(npc, "My brother went to the mountain in the south, if you find him, let him know that I'm looking for him.")
				end
			else
				NPCspeak(npc, "My brother went to the mountain in the south, if you find him, let him know that I'm looking for him.")
				PLAYERS[id].FederigoBrother = 1
			end
		end
	elseif state == 2 then
		if contains(words, "yes") then
			if addmoney(id, -10) then
				message(id, "You have lost $10.", "255255255")
				NPCspeak(npc, "Have a good rest!")
				parse("setpos " .. id .. " 784 112")
				PLAYERS[id].Spawn = {784, 240}
				PLAYERS[id].tmp.npcstate = nil
			else
				NPCspeak(npc, "Don't try to enter without paying!")
				PLAYERS[id].tmp.npcstate = nil
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Alright then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	elseif state == 3 then
		if contains(words, "sorry") or contains(words, "apologise") or contains(words, "apologize") then
			addmoney(id, 300)
			message(id, "You have recieved $300.", "255255255")
			NPCspeak(npc, "Really? He's apologising to me... Thank's for you help! Here's a small token of appreciation from me.")
			PLAYERS[id].FederigoBrother = 0
			PLAYERS[id].tmp.npcstate = nil
		end
	end
end
tibia.config.npc[4].func = function(npc, id, words, state)
	if contains(words, "hi") then
		NPCspeak(npc, "...")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "...")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if PLAYERS[id].FederigoBrother then
			if contains(words, "brother") or contains(words, "federigo") then
				if PLAYERS[id].FederigoBrother == 1 or PLAYERS[id].FederigoBrother == 2 then
					NPCspeak(npc, "Don't talk about him. Its dark here, I need a torch.")
					PLAYERS[id].FederigoBrother = 2
				elseif PLAYERS[id].FederigoBrother == 3 then
					NPCspeak(npc, "Don't talk about him. I feel a little hungry now, can you please get me an apple?")
				elseif PLAYERS[id].FederigoBrother == 4 then
					NPCspeak(npc, "Do you really want to know about my brother?")
					PLAYERS[id].tmp.npcstate = {npc, 2}
				elseif PLAYERS[id].FederigoBrother == 0 then
					NPCspeak(npc, "Thanks for helping me!")
				else
					NPCspeak(npc, "Yes, that's him. Can you tell him that I'm looking for him?")
				end
			elseif contains(words, "torch") then
				if PLAYERS[id].FederigoBrother == 2 then
					if removeitem(id, 2) then
						NPCspeak(npc, "Thank you! However, I feel a little hungry now, can you please get me an apple?")
						PLAYERS[id].FederigoBrother = 3
						return
					end
				end
				NPCspeak(npc, "Its dark here, I need a torch.")
			elseif contains(words, "apple") then
				if PLAYERS[id].FederigoBrother == 3 then
					if removeitem(id, 1) then
						PLAYERS[id].FederigoBrother = 4
						NPCspeak(npc, "Oh thank you! Do you really want to know about my brother?")
						PLAYERS[id].tmp.npcstate = {npc, 2}
						return
					end
					NPCspeak(npc, "Mmm ... If only I could have an apple.")
				end
			end
		else
			NPCspeak(npc, "I have a brother, but he can't be found anywhere.")
		end
	elseif state == 2 then
		NPCspeak(npc, "My brother's name is Federigo. I left town after we fell out and ")
		NPCspeak(npc, "we never talked since. Tell him that I'm sorry, please.")
		PLAYERS[id].tmp.npcstate = {4, 1}
	end
end
tibia.config.npc[7].func = function(npc, id, words, state)
	if contains(words, "hi") then
		if PLAYERS[id]["CheeseQuest"] then
			if PLAYERS[id]["CheeseQuest"] == 0 then
				NPCspeak(npc, "Hello, there!")
			else
				NPCspeak(npc, "Did you get them?")
				PLAYERS[id].tmp.npcstate = {npc, 3}
			end
		else
			NPCspeak(npc, "Hello. Hey, you look like you have a lot of spare time, do you?")
			PLAYERS[id].tmp.npcstate = {npc, 1}
		end
	elseif contains(words, "bye") then
		NPCspeak(npc, "Bye.")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "yes") then
			NPCspeak(npc, "Oh! Then, you can do me a favour, right?")
			PLAYERS[id].tmp.npcstate = {npc, 2}
		else
			NPCspeak(npc, "Nevermind, then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	elseif state == 2 then
		if contains(words, "yes") then
			NPCspeak(npc, "Thanks! Well, I'm currently working, but I haven't had any meals!")
			NPCspeak(npc, "Can you get me 10 slices of cheese? I heard that Ratatas carry them around frequently.")
			PLAYERS[id]["CheeseQuest"] = 1
			PLAYERS[id].tmp.npcstate = {npc, 1}
		else
			NPCspeak(npc, "Nevermind, then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	elseif state == 3 then
		if contains(words, "yes") then
			if removeitem(id, 4, 10, true) then
				addmoney(id, 300)
				message(id, "You have recieved $300.", "255255255")
				NPCspeak(npc, "Thanks! Here's a reward, I earn much more than that anyway.")
				PLAYERS[id]["CheeseQuest"] = 0
				PLAYERS[id].tmp.npcstate = {npc, 0}
			else
				NPCspeak(npc, "I need 10 slices of cheese, now!")
				PLAYERS[id].tmp.npcstate = nil
			end
		else
			NPCspeak(npc, "Well? What are you waiting for?")
			PLAYERS[id].tmp.npcstate = nil
		end
	end
end
tibia.config.npc[9].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Welcome! Say 'rest' if you need to take a break.")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Goodbye.")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "rest") then
			NPCspeak(npc, "Would you like to rest in the inn for $10?")
			PLAYERS[id].tmp.npcstate = {npc, 2}
		end
	elseif state == 2 then
		if contains(words, "yes") then
			if addmoney(id, -10) then
				message(id, "You have lost $10.", "255255255")
				NPCspeak(npc, "Have a good rest!")
				parse("setpos " .. id .. " 2704 1040")
				PLAYERS[id].Spawn = {2704, 1040}
				PLAYERS[id].tmp.npcstate = nil
			else
				NPCspeak(npc, "Don't try to enter without paying!")
				PLAYERS[id].tmp.npcstate = nil
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Alright then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	end
end
tibia.config.npc[10].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Hello! Would you like to go to the new island for $10?")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Goodbye.")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "yes") then
			if addmoney(id, -10) then
				message(id, "You have lost $10.", "255255255")
				NPCspeak(npc, "Bon voyage!")
				parse("setpos " .. id .. " 3632 2448")
				PLAYERS[id].tmp.npcstate = nil
			else
				NPCspeak(npc, "Don't try to enter without paying!")
				PLAYERS[id].tmp.npcstate = nil
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Alright then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	end
end
tibia.config.npc[11].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Hello! Would you like to go to the old island for $10?")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Goodbye.")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "yes") then
			if addmoney(id, -10) then
				message(id, "You have lost $10.", "255255255")
				NPCspeak(npc, "Bon voyage!")
				parse("setpos " .. id .. " 2832 1872")
				PLAYERS[id].tmp.npcstate = nil
			else
				NPCspeak(npc, "Don't try to enter without paying!")
				PLAYERS[id].tmp.npcstate = nil
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Alright then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	end
end
tibia.config.npc[12].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Welcome! Say 'rest' if you need to take a break.")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Goodbye.")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "rest") then
			NPCspeak(npc, "Would you like to rest in the inn for $10?")
			PLAYERS[id].tmp.npcstate = {npc, 2}
		end
	elseif state == 2 then
		if contains(words, "yes") then
			if addmoney(id, -10) then
				message(id, "You have lost $10.", "255255255")
				NPCspeak(npc, "Have a good rest!")
				parse("setpos " .. id .. " 4048 1584")
				PLAYERS[id].Spawn = {4048, 1584}
				PLAYERS[id].tmp.npcstate = nil
			else
				NPCspeak(npc, "Don't try to enter without paying!")
				PLAYERS[id].tmp.npcstate = nil
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Alright then.")
			PLAYERS[id].tmp.npcstate = nil
		end
	end
end

--[[if not tibia.global.NPC13 then
	tibia.global.NPC13 = 0
end

tibia.config.npc[13].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Care for a gamble? I'll roll a dice and if you get what you chose, you'll win 6 fold.")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Oh, you don't want to win?")
		PLAYERS[id].tmp.npcstate = nil
	elseif PLAYERS[id].tmp.npcstate == 3 or PLAYERS[id].tmp.dice then
		local number = tonumber(words)
		if number == 1 or number == 2 or number == 3 or number == 4 or number == 5 or number == 6 then
			local random = math.random(6)
			if random == number then
				local earning = PLAYERS[id].tmp.dice*6
				addmoney(id, earning)
				tibia.global.NPC13 = tibia.global.NPC13 - earning
				message(id, "You have recieved $" .. earning .. ".", "255255255")
				NPCspeak(npc, "You rolled a " .. random .. ". You won! Here's $" .. earning .. " as the prize.")
			else
				NPCspeak(npc, "You rolled a " .. random .. ". You lost. How about trying again?")
			end
			PLAYERS[id].tmp.npcstate = {npc, 1}
			PLAYERS[id].tmp.dice = nil
		else
			NPCspeak(npc, "Pick a number from 1-6!")
		end
	elseif state == 1 then
		if contains(words, "yes") or contains(words, "gamble") or contains(words, "bet") then
			NPCspeak(npc, "How much do you want to bet?")
			PLAYERS[id].tmp.npcstate = {npc, 2}
		elseif contains(words, "no") then
			NPCspeak(npc, "Oh, you don't want to win?")
		elseif contains(words, "earning") or contains(words, "rupee") then
			NPCspeak(npc, "I have $" .. tibia.global.NPC13 .. " currently.")
		end
	elseif state == 2 then
		local bet = tonumber(words)
		if bet and bet >= 1 then
			bet = math.floor(bet)
			if addmoney(id, -bet) then
				tibia.global.NPC13 = tibia.global.NPC13 + bet
				message(id, "You have lost $" .. bet .. ".", "255255255")
				PLAYERS[id].tmp.dice = bet
				NPCspeak(npc, "You'll win $" .. bet*6 .. " if you pick the correct number! Pick a number from 1-6!")
				PLAYERS[id].tmp.npcstate = {npc, 3}
			else
				NPCspeak(npc, "You don't have that much rupee!")
				PLAYERS[id].tmp.npcstate = {npc, 1}
			end
		else
			NPCspeak(npc, "You can't bet that!")
			PLAYERS[id].tmp.npcstate = {npc, 1}
		end
	end
end]]
tibia.config.npc[14].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "The toll is $10. Do you want to cross this bridge?")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Not crossing?")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "yes") then
			if addmoney(id, -10) then
				message(id, "You have lost $10.", "255255255")
				parse("setpos " .. id .. " 3536 1264")
			else
				NPCspeak(npc, "No rupee, no crossing.")
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Not crossing?")
		end
		PLAYERS[id].tmp.npcstate = nil
	end
end
tibia.config.npc[17].func = function(npc, id, words, state)
	if words == "hi" then
		NPCspeak(npc, "Hey! Do you want to enter the PVP zone? You need to have at least $100 so you can drop them when you die!")
		PLAYERS[id].tmp.npcstate = {npc, 1}
	elseif contains(words, "bye") then
		NPCspeak(npc, "Goodbye!")
		PLAYERS[id].tmp.npcstate = nil
	elseif state == 1 then
		if contains(words, "yes") then
			if getmoney(id) >= 100 then
				parse("setpos " .. id .. " 3056 1040")
			else
				NPCspeak(npc, "Aww... You don't even have $100!")
			end
		elseif contains(words, "no") then
			NPCspeak(npc, "Okay! Come back when you want!")
		end
		PLAYERS[id].tmp.npcstate = nil
	end
end

--[[

addhook("menu", "NPCmenu")
function NPCmenu(id, title, button)
	for i, v in ipairs(tibia.config.npc) do
		if title == v[1] then
			if button == 0 then
				if v.bye then
					NPCspeak(i, v.bye)
				end
				return
			end
			local itemid = math.abs(v.trade[button][1])
			if itemid then
				sell = v.trade[button][1] < 0
				price = v.trade[button][2]
				radiusmsg(string.format("�255255100%s %s says : %s %s", os.date'%X', player(id, 'name'), price > 0 and "buy" or "sell", tibia.config.item[itemid].name), player(id, 'x'), player(id, 'y'))
				if sell then
					if removeitem(id, itemid, 1, true) then
						addmoney(id, price)
						message(id, "You have recieved $" .. price .. ".", "255255255")
						msg2(id, "You have sold " .. tibia.config.item[itemid].article .. " " .. tibia.config.item[itemid].name .. " for $" .. price .. ".")
						return menu(id, tibia.config.npc[i].menu)
					end
					msg2(id, "You do not have " .. tibia.config.item[itemid].article .. " " .. tibia.config.item[itemid].name .. " to sell.")
					return
				elseif addmoney(id, -price) then
					if additem(id, itemid, 1, true) then
						message(id, "You have lost $" .. price .. ".", "255255255")
						msg2(id, "You have bought " .. tibia.config.item[itemid].article .. " " .. tibia.config.item[itemid].name .. " for $" .. price .. ".")
						return menu(id, tibia.config.npc[i].menu)
					end
					msg2(id, "You do not have enough capacity.")
					return
				end
				msg2(id, "You do not have enough rupee.")
			end
			return
		end
	end
end]]