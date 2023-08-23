class_name DialogueSystem
extends Control


signal dialogue_completed

var portrait_rect: TextureRect
var name_label: Label
var dialogue_label: RichTextLabel
var choices_container: Control


func _animate() -> void:
	pass


func _set_speaker_portrait(portrait: Texture) -> void:
	pass


func _set_speaker_name(name: String) -> void:
	pass


func _set_dialogue_message(msg: String) -> void:
	pass
