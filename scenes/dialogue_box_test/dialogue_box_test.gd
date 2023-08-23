extends Control


func _ready() -> void:
	DialogueManager.register_dialogue_controller($dialogue_panel)
	await DialogueManager.show_dialogue("Hi!")
	
	DialogueManager.set_speaker_portrait(preload("res://icon.svg"))
	DialogueManager.set_speaker_name("icon.svg")
	await DialogueManager.show_dialogue("My name is [code]icon.svg[/code]!")
	await DialogueManager.show_dialogue("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut consequat at augue eu pretium. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus ac elit tincidunt, suscipit dui at, luctus purus. Pellentesque id imperdiet nunc, id dapibus turpis. Cras venenatis magna sit amet erat commodo, eu varius metus suscipit. Maecenas vestibulum odio libero, id lacinia mi elementum ac. Sed eleifend aliquet tortor et placerat. Donec vitae nibh rutrum, sollicitudin quam et, ultrices nunc. Mauris venenatis felis id tempor viverra. Cras ante turpis, fringilla sit amet turpis ac, mattis sagittis nisl. Aenean sit amet tortor urna. Ut suscipit sem id ex ultrices, eget egestas nulla congue.")
	DialogueManager.hide_dialogue()
