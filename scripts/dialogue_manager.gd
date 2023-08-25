extends Node

var controller: DialogueSystem

func register_dialogue_controller(ctrl: DialogueSystem) -> void:
	if controller != null:
		controller.queue_free()
	controller = ctrl
	
	controller.visible = false
	controller._set_speaker_portrait(null)
	controller._set_speaker_name("")
	controller._set_choices([])


func show_dialogue(dialogue: String) -> void:
	controller.visible = true
	controller._set_dialogue_message(dialogue)
	controller._animate()
	await controller.dialogue_completed


func hide_dialogue() -> void:
	controller.visible = false


func set_speaker_portrait(portrait: Texture) -> void:
	controller._set_speaker_portrait(portrait)


func set_speaker_name(name: String) -> void:
	controller._set_speaker_name(name)


func show_choices(choices: Array[String]) -> int:
	controller._set_choices(choices)
	var result := await controller.choice_selected as int
	controller._set_choices([])
	return result
