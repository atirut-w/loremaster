extends NPC

func _ready():
	name_in_events = CHARACTER_AXE

func play_interaction():
	await introduce(first_meet_sequence,later_meet_sequence)
	
	
func first_meet_sequence():
	await say("HI!")
	
	await choice(["Hi", "Hello", "Hey"], [player_said_hi,player_said_hello,player_said_hey])
	

func later_meet_sequence():
	if event_tracker.has_player_done("upset_npc"):
		await say("I don't talk to rude people!")
		await say("Bye!")
	elif event_tracker.has_player_done("excite_npc"):
		await say("You're my best friend!")
	else:
		await say("HELLO!")
		
		if event_tracker.has_player_done("intrigue_npc"):
			await choice(["Hi", "Hello"], [player_said_hi_twice,player_said_hello])

func player_said_hi():
	await say("I like you!")
	await say("Bye!")
	event_tracker.make_player_do("intrigue_npc")
	

func player_said_hi_twice():
	await say("You're the best!")
	await say("Bye!")
	event_tracker.make_player_do("excite_npc")
	

func player_said_hello():
	await say("Bye!")
	
	
func player_said_hey():
	await say("I don't like your tone!")
	event_tracker.make_player_do("upset_npc")
	
	await say("Bye.")
	
	
