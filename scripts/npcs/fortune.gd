extends NPC

func _ready():
	name_in_events = CHARACTER_FORTUNE
	

func play_interaction():
	await introduce(initial_encounter, later_encounters)
	
	await help()

func initial_encounter():
	await say("Greetings loremaster, I heard of the quest that king has gave you. I anticipate your arrival to my library.")
	await say("I am Fortune, the librarian of this building. I hope that I may assist you in your quest.")

func later_encounters():
	await say("Greetings again loremaster.")

func help(asked_again :bool=false):
	if asked_again:
		await say("Is there anything else you would like to know about today?")
	else:
		await say("What is it that you seek today?")
	
	var choices_to_sequences = {}
	
	if !told_about(LORE_GIANTS_CAVE):		
		var access_to_the_giants_cave = func ():
			if event_tracker.has_player_done(EVENT_SCHOLAR_APPROVAL_GIVEN):
				await say("I have heard that my fellow scholars see you fit for tampering with the volatile world that involves the ancients.")
				await say("I shall advise you to remember the damage that the disruption of these forces may cause.")
				await say("Be wary loremaster!")
				await say("As for the location of the Giant's Cave however, it can be seen in the Markan-Natura plains adjacent to an unmissable ring of flowers.")
				await say("One must stand in the ring of flowers to see the cave manifest itself in the walls of the mountains.")
				await say("I'd advise to bring an companion, the Markan-Natura plains have a tendency to defend against any percieved disruption to the ancients.")
				
				teach(LORE_GIANTS_CAVE)
			else:
				await say("Even though it is your quest, I'm afraid that I cannot give you that information until my fellow scholars approve of you handling that information.")
				await say("The ancient powers involved in powering the Giant are not ones that should be tampered with.")
			
				teach(LORE_GIANT)
				
			await help(true)
				
		choices_to_sequences["Access to the Giant's Cave"] = access_to_the_giants_cave
	
	var fish_choices_to_sequences = {}
	
	if player_heard_of_but_not_told_about(LORE_FISHERMANS_PERIL):
		var fishermans_peril = func ():
			await say("One moment, I imagine that fish is mentioned in a book about intercontinental fishing legends!")
			await say("I have found this extract:")
			await say("The Fisherman's Peril, is a fish that tricks fisherman into thinking they are catching a good catch.")
			await say("Only for the Fisherman's Peril itself to attack the fisherman once caught.")
			
			teach(LORE_FISHERMANS_PERIL)
			
		fish_choices_to_sequences["Fisherman's Peril"] = fishermans_peril
		
	if player_heard_of_but_not_told_about(LORE_SAND_FISH):
		var sand_fish = func ():
			await say("I myself am familar with the legend on the Sand Fish. Though I do not believe they exist.")
			await say("You might find this extract enlightening:")
			await say("In the continent of Langar, King Alfie once ordered an excavation of all the beaches in the land.")
			await say("This excavation was so intense it removed all of the beaches from the continent. But why did King Alfie do it?")
			await say("King Alfie was in search of a Sand Fish, though after sifting the sand through fine nets, not a single Sand Fish was found.")
			
			teach(LORE_SAND_FISH)
			
		fish_choices_to_sequences["Sand Fish"] = sand_fish
		
	if player_heard_of_but_not_told_about(LORE_SPIRIT_FISH):
		var spirit_fish = func ():
			await say("Here I found this extract from 'Catching a Spirit Fish':")
			await say("Spirit Fish are said to be messengers to the Water Elemental. Although this is likely a misconception due to the fact that Spirit Fish are used in rituals to contact the Elementals.")
			await say("Spirit Fish themselves are most commonly present at high tide. Though you could not catch one like a convential fish.")
			await say("Instead you must lace a net with an anti-phasing component to prevent the fish phasing through the net.")
			await say("It is debated as to what allows anti-phasing but anything that reveals the Spirit Fish, even temporarily, is most definitely anti-phasing.")
			
		fish_choices_to_sequences["Spirit Fish"] = spirit_fish
		
	if fish_choices_to_sequences.size() != 0:
		fish_choices_to_sequences["Nevermind"] = empty_sequence
		
		var knowledge_about_fish = func ():
			await say("Of course, we have several volumes about local aquatic life.")
			await say("Which fish would you like to know more about?")
			
			await choice(fish_choices_to_sequences)
			
			await help(true)
		
		choices_to_sequences["Knowledge about fish"] = knowledge_about_fish
	
	choices_to_sequences["That is all for now"] = empty_sequence
	
	await choice(choices_to_sequences)
		
