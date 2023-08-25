extends Node

func _ready():
	$TestNPC.register_event_tracker($WorldEvents)
	
	await $"TestNPC".interact()
	await $"TestNPC".interact()
	await $"TestNPC".interact()
