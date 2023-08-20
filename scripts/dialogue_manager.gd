extends Node

signal message(dialogue, choices)
signal end_of_dialogue

const STATIC_DIALOGUE = TYPE_STRING
const CHOICE_DIALOGUE = TYPE_DICTIONARY
const CONDITIONAL_DIALOGUE = TYPE_CALLABLE
const GROUPED_DIALOGUE = TYPE_ARRAY

const DIALOGUE_INFO_KEY = "info"
const NO_CHOICE = "NO_CHOICE"

var dialogues = []

func progress(choice=NO_CHOICE):
	if dialogues.size() > 0:
		var dialogue = dialogues.front()
		#For static dialogue, emit the dialogue with no choices
		if typeof(dialogue) == STATIC_DIALOGUE:
			dialogues.pop_front()
			message.emit(dialogue,{})
		#For choice dialogue, emit a header with choices if no choice is made
		#Otherwise get dialogue from choice, replace with front and then progress
		if typeof(dialogue) == CHOICE_DIALOGUE:
			if choice == NO_CHOICE:
				message.emit(dialogue[DIALOGUE_INFO_KEY], dialogue)
			else:
				var new_dialogue = dialogue[choice]
				_replace_dialogue_at_front(new_dialogue)
				progress()
		#Execute conditional diagonal, replace with front of list and then progress
		if typeof(dialogue) == CONDITIONAL_DIALOGUE:
			var new_dialogue = dialogue.call()
			_replace_dialogue_at_front(new_dialogue)
			progress()
		#For an empty grouped dialog, remove and then progress
		#For grouped dialog, get first element and put to front of list and them progress
		if typeof(dialogue) == GROUPED_DIALOGUE:
			if dialogue.size() == 0:
				dialogues.pop_front()
				progress()
			else:
				var new_dialogue = dialogue.pop_front()
				dialogues.push_front(new_dialogue)
				progress()
	else:
		end_of_dialogue.emit()
			
#Add dialogue to the dialogue list, does not work for CHOICE_DIALOGUE
func add_dialogue(dialogue):
	if typeof(dialogue) != CHOICE_DIALOGUE:
		dialogues.push_back(dialogue)
	
#Add a group of choices with a header to the dialogue list
func add_choice_dialogue(info, dialogue):
	if typeof(dialogue) == CHOICE_DIALOGUE:
		dialogue[DIALOGUE_INFO_KEY] = info
		dialogues.push_back(dialogue)
		
func _replace_dialogue_at_front(dialogue):
	dialogues.pop_front()
	dialogues.push_front(dialogue)

