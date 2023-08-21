extends Label

signal read
signal submit_choice(choice)

var dialogues = []
var choices = []
var reading = false

var text_to_display = ""
var timer = 0

func _ready():
	$SubmitText.disabled = false
	$StartDialog.disabled = true
	$Choices.disabled = true
	$ChooseChoice.disabled = true
	$AddChoice.disabled = false
	$Choices.clear()
	
	
func _process(delta):
	if reading:
		if Input.is_action_just_pressed("dialogue_continue"):
			if text_to_display == text:
				read.emit()
			else:
				text = text_to_display


func _on_submit_text_pressed():
	var text_to_submit = $AddText.text
	$AddText.clear()
	dialogues.push_back(text_to_submit)
	
	$StartDialog.disabled = false
	

func _on_start_dialog_pressed():
	if choices.size() != 0:
		var choice = await $DialogueManager.show_choices(dialogues,choices)
		text = "You have chosen " + choice
	else:
		$DialogueManager.show_dialog(dialogues)
	dialogues = []
	choices = []


func _on_dialogue_manager_message(dialogue):
	text = ""
	text_to_display = dialogue
	
	
func _on_dialogue_manager_end_of_dialogue():
	if choices.size() == 0:
		text = "EOD"
		$StartDialog.disabled = true
		$SubmitText.disabled = false
	$TextSpeed.stop()
	reading = false
	

func _on_dialogue_manager_start_of_dialogue():
	$StartDialog.disabled = true
	$SubmitText.disabled = true
	$AddChoice.disabled = true
	$TextSpeed.start()
	reading = true

	read.emit()


func _on_text_speed_timeout():
	if text.length() != text_to_display.length():
		text += text_to_display[text.length()]
		
	$TextSpeed.start()


func _on_add_choice_pressed():
	var choice_to_submit = $AddText.text
	$AddText.clear()
	choices.push_back(choice_to_submit)
	
	$StartDialog.disabled = false


func _on_dialogue_manager_start_of_choices(options):
	for option in options:
		$Choices.add_item(option)
		
	$Choices.disabled = false
	$ChooseChoice.disabled = false
	


func _on_choose_choice_pressed():
	var choice = $Choices.get_item_text($Choices.selected)
	submit_choice.emit(choice)
	
	_ready()
