extends Node


func _on_interact_pressed():
	var npc = find_child($NPCs.get_item_text($NPCs.selected))
	npc.register_event_tracker($WorldEvents)
	$Interact.disabled = true
	
	await npc.interact()

	$Interact.disabled = false
