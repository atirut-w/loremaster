extends DialogueSystem


@export var dialogue_speed := 25.0

var animating := false
@onready var dialogue_label := $dialogue_hbox/dialogue_label


func _ready() -> void:
	DialogueManager.register_dialogue_controller(self)


func _set_speaker_portrait(portrait: Texture) -> void:
	if portrait != null:
		$dialogue_hbox/character_info/portrait.visible = true
		$dialogue_hbox/character_info/portrait.texture = portrait
	else:
		$dialogue_hbox/character_info/portrait.visible = false


func _set_speaker_name(name: String) -> void:
	if name != "":
		$dialogue_hbox/character_info/name.visible = true
		$dialogue_hbox/character_info/name.text = name
	else:
		$dialogue_hbox/character_info/name.visible = false


func _set_dialogue_message(msg: String) -> void:
	$dialogue_hbox/dialogue_label.text = msg


# TODO: Test
func _set_choices(choices: Array[String]) -> void:
	var container := $dialogue_hbox/choices_container
	
	for child in container.get_children():
		child.queue_free()
	if choices.size() == 0:
		return
	
	for i in choices.size():
		var choice := choices[i]
		var button := Button.new()
		button.text = choice
		button.pressed.connect(func(): choice_selected.emit(i))
		
		container.add_child(button)


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
