extends NPC

func _ready():
	name_in_events = CHARACTER_JARED
	

func play_interaction():
	await introduce(opening_sequence, later_sequences)
	

func opening_sequence():
	await say("Loremaster, I have invitied you to my grounds, as I have quest for you.")
	await say("Scholars throughout the kingdom have found out about the Giant's Cave, a cave which is said to hold legendary amounts of treasure.")
	await say("I entrust you with finding more about this cave and how to retrieve it's treasures, so that together we can make the kingdom prosperous!")
	
	var question_about_treasure = func ():
		await say("We shall use the treasure, to help those who are impoverished or in sickness.")
		
		var praise_the_king = func ():
			await say("[color=green]I'm glad that you see it as such![/color] With your help, we will help that become a reality, so set forth loremaster!")
			await say("Delve deeper into all there is to know about the Giant's Cave. I'm sure a great adventure awaits you!")
		
			trigger_event(EVENT_PRAISE_KING_JARED)
		
		var doubt_the_king = func ():
			await say("We have not had the means to loremaster, [color=red]I would watch your tone when speaking to royalty[/color].")
			await say("I don't imagine you'd want your quest to fall short.")
			
			trigger_event(EVENT_DOUBT_KING_JARED)
		
		await choice({
			"What a noble cause!": praise_the_king,
			"Why haven't you helped the sick before?": doubt_the_king
		})
		
	var question_about_whereabouts = func ():
		await say("Our scholars have gathered that the Giant's Cave is located in the Markan-Natura Plains. Search for information around there.")
		teach(LORE_GIANTS_CAVE)
	
	await choice({
		"What will you do with the treasure?": question_about_treasure,
		"Whereabouts is the Giant's Cave?": question_about_whereabouts
	})
	
	if seen_event(EVENT_DOUBT_KING_JARED):
		await say("Now be gone! Your quest will be full of challenges, so set forth!")
	else:
		await say("I look forward to hearing about your progress in the future!")
		
		
func later_sequences():
	if seen_event(EVENT_DOUBT_KING_JARED):
		await say("Enter loremaster, tell me how your quest has been going?")
	else:
		await say("It's good to see you again loremaster, how have you been getting along with your quest?")
		
	
