class_name DialogueSystem
extends Control


signal dialogue_completed
signal choice_selected(id: int)


func _animate() -> void:
	pass


func _set_speaker_portrait(portrait: Texture) -> void:
	pass


func _set_speaker_name(name: String) -> void:
	pass


func _set_dialogue_message(msg: String) -> void:
	pass


func _set_choices(choices: Array[String]) -> void:
	pass
