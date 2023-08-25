extends NPC

func _ready():
	name_in_events = CHARACTER_SAMUEL
	
func play_interaction():
	await introduce(initial_encounter, later_encounters)
	
	await help()
	
func initial_encounter():
	await say("Greetings there! I'm Samuel, a fisherman at these ports.")
	await say("Who are you?")
	
	var tell_truth = func ():
		await say("How interesting! Might I ask what you are looking to find out about?")
		
		var the_giants_cave = func ():
			await say("I have heard of the Giant, but never of his cave. There used to be tales of the Giant aiding fisherman navigate the waters.")
			await say("It is believed the Giant himself has always had a great affinity towards water.")
			
			teach(LORE_GIANT)
			
		var legendary_fish = func ():
			await say("I know of many legendary fish in these waters!")
			await say("One of them is the known as the Fisherman's Peril, it is said to have caused the death of many fisherman!")
			await say("It is said to recide in deep sea, luckily far away from these ports.")
			await say("There it lurks to await for fisherman looking for a catch. The unsuspecting fisherman will feel a tug and reel in their catch.")
			await say("Only for them to surface a monster!")
			
			teach(LORE_FISHERMANS_PERIL)
			
			var hear_more_about_fish = func ():
				await say("The tales of the Fisherman's Peril come from fisherman who say they witnessed the beast from the safety of their own boat.")
				await say("Though any fisherman that has saw the horror of the Fisherman's Peril, set into motion right away!")
				
				await say("There are also legends of more local fish, one of those is the Sand Fish.")
				await say("Its veins are said to contain ambrosia, which makes them incomprehensibly delicious.")
				await say("If a fishmonger got his hands on one, I'm sure royalty from across the lands would pay fortunes for a single slice!")
				await say("Unfortunately for that fishmonger, the fish themselves are said to swim in the sands instead of the water.")
				await say("So I cannot imagine they would lay their hands on one anytime soon.")
				
				teach(LORE_SAND_FISH)
				
				var learn_more_about_fish = func ():
					await say("There is another fish I know of. I think I may have even seen it in the flesh!")
					await say("I was at the Oklan Fishery, when all of the sudden a poor fisherman slipped and tipped a barrel of spices into the water.")
					await say("After that, I saw fish coming to nibble at the spices in the water.")
					await say("One of the was glowing lighting, similar of how legends described the appearance of a fish that is said to act as a messenger for the Water Elemental.")
					
					teach(LORE_WATER_ELEMENTAL)
					
					await say("It's called the Spirit Fish. I wish I could've seen it in greater detail but it left my sight as suddenly as I saw it.")
					await say("I think those must have been some special spices, to bring such a celestial fish to them!")
					
					teach(LORE_SPIRIT_FISH)
					
					await say("That is all I will say for now about fish legends. I hope you found that information useful!")
					
				
				await choice(["I'd love to hear more about legendary fish!", "I think that's all I need to know..."], [learn_more_about_fish,empty_sequence])
			
			await choice(["How interesting! Tell me more!", "I think I've heard enough..."], [hear_more_about_fish,empty_sequence])
			
		var cannot_know = func ():
			await say("I apologize for intruding. I hope you will find whatever you may need.")
		
		await choice(["The Giant's Cave","Legendary Fish","I'm afraid you cannot know"], [the_giants_cave, legendary_fish, cannot_know])
		
	var tell_lie = func ():
		await say("Oh really? I have never seen you around these ports.")
		await say("Where did you learn how to fish?")
		
		var lie_about_dnalhsif = func():
			await say("I cannot say I've ever heard of it, I imagine you're not originally of this continent.")
			await say("How come you have came over to Jared?")
			
			var fish_in_new_waters = func ():
				await say("Said like a true fisherman!")
				
				trigger_event(EVENT_PRETEND_TO_BE_FISHERMAN)
			
			var came_to_travel = func ():
				await say("Well, I hope you enjoy your travels!")
			
			await choice(["I have come to fish in new waters!","I have came to travel"],[fish_in_new_waters,came_to_travel])
		
		await choice(["D... Dnalhsif"],[lie_about_dnalhsif])
	
	await choice(["I am a loremaster","I too am a fisherman"], [tell_truth,tell_lie])
	
	
func later_encounters():
	await say("Hello there again!")


func help():
	await say("Is there anyway I can help you?")
	
	await choice(["Not right now!"], [empty_sequence])
	
	await say("Alright, goodbye!")
