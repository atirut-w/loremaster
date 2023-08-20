extends Node

signal start_of_dialogue
signal message(dialogue)
signal end_of_dialogue

signal start_of_choices(options)
signal end_of_choices

const SINGLE_DIALOGUE = TYPE_STRING
const GROUPED_DIALOGUE = TYPE_ARRAY

var dialogues = []
var choice = ""

func _read_dialog():
	if dialogues.size() > 0:
		var dialogue = dialogues.pop_front()
		message.emit(dialogue)
	else:
		end_of_dialogue.emit()

func show_dialog(dialogue):
	if typeof(dialogue) == SINGLE_DIALOGUE:
		dialogues = [dialogue]
	if typeof(dialogue) == GROUPED_DIALOGUE:
		dialogues = dialogue
		
	start_of_dialogue.emit()
	
	await end_of_dialogue
	
func show_choices(dialogue, options):
	await show_dialog(dialogue)
	
	choice = ""
	start_of_choices.emit(options)
	
	await end_of_choices
	
	return choice
	
func _submit_choice(option):
	choice = option
	end_of_choices.emit()
