extends Label

var choiceConstructor = {}

func _ready():
	$PlayerChoice.disabled = true


func _on_submit_text_pressed():
	var text_to_submit = $AddText.text
	$AddText.clear()
	
	if $CustomChoice.selected == 0:
		if choiceConstructor.keys().size() == 0:
			$DialogueManager.add_dialogue(text_to_submit)
		else:
			$DialogueManager.add_choice_dialogue(text_to_submit, choiceConstructor)
			choiceConstructor = {}
	else:
		var selected = str($CustomChoice.get_item_text($CustomChoice.selected))
		if !choiceConstructor.has(selected):
			choiceConstructor[selected] = []
		choiceConstructor[selected].push_back(text_to_submit)


func _on_progress_pressed():
	if $PlayerChoice.disabled:
		$DialogueManager.progress()
	else:
		$DialogueManager.progress(str($PlayerChoice.get_item_text($PlayerChoice.selected)))
	
	if !$PlayerChoice.has_selectable_items():
		$PlayerChoice.disabled = true


func _on_dialogue_manager_message(dialogue, choices):
	text = dialogue
	
	$PlayerChoice.clear()
	for choice in choices.keys():
		$PlayerChoice.disabled = false
		if choice != "info":
			$PlayerChoice.add_item(choice)
			
		

func _on_dialogue_manager_end_of_dialogue():
	text = "EOD"
