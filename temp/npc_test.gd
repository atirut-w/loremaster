extends Node

func _ready():
	$DialogueManager.register_dialogue_controller($dialogue_panel)
	$TestNPC.register_event_tracker($WorldEvents)
	$TestNPC.register_dialogue_manager($DialogueManager)
	
	await $"TestNPC".interact()
	await $"TestNPC".interact()
	await $"TestNPC".interact()
