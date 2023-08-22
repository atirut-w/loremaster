extends Node

var controller: DialogueSystem

func register_dialogue_controller(ctrl: DialogueSystem) -> void:
	if controller != null:
		controller.queue_free()
	controller = ctrl
	
	controller.portrait_rect.visible = false
	controller.name_label.visible = false
	controller.choices_container.visible = false


func show_dialogue(dialogue: String) -> void:
	controller.dialogue_label.text = dialogue
	controller._animate()
	await controller.dialogue_completed


func set_speaker_portrait(portrait: Texture) -> void:
	if portrait != null:
		controller.portrait_rect.visible = true
		controller.portrait_rect.texture = portrait
	else:
		controller.portrait_rect.visible = false


func set_speaker_name(name: String) -> void:
	if name != null:
		controller.name_label.visible = true
		controller.name_label.text = name
	else:
		controller.name_label.visible = false
