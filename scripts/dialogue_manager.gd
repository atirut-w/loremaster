extends Node

var controller: DialogueSystem

func register_dialogue_controller(ctrl: DialogueSystem) -> void:
	if controller != null:
		controller.queue_free()
	controller = ctrl


func show_dialogue(dialogue: String) -> void:
	controller.dialogue_label.text = dialogue
	controller._animate()
	await controller.dialogue_completed
