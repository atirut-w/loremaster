extends DialogueSystem


@export var dialogue_speed := 25.0

var animating := false


func _ready() -> void:
	portrait_rect = $dialogue_hbox/character_info/portrait
	name_label = $dialogue_hbox/character_info/name
	dialogue_label = $dialogue_hbox/dialogue_label
	choices_container = $dialogue_hbox/choices_container


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			if animating:
				animating = false
				dialogue_label.visible_ratio = 1.0
			else:
				dialogue_completed.emit()


func _animate() -> void:
	animating = true
	dialogue_label.visible_ratio = 0.0


func _physics_process(delta: float) -> void:
	if animating:
		if dialogue_label.visible_ratio < 1.0:
			dialogue_label.visible_ratio += (dialogue_speed / float(dialogue_label.text.length())) * delta
		else:
			animating = false
