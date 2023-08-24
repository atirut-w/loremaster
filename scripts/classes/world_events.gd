class_name WorldEvents
extends Node

@export var save_id: String
var filepath = "user://"+save_id+".save"
var event_tree: Dictionary = {}


func _create_save() -> void:
	#Will overwrite an existing save
	#will need to warn user if overwrite is possible
	var save_game = FileAccess.open(filepath, FileAccess.WRITE)
	var save_json = JSON.stringify({})
	if event_tree:
		save_json = JSON.stringify(event_tree)
		
	save_game.store_line(save_json)	


func _load_save() -> void:
	if FileAccess.file_exists(filepath):
		var save_game = FileAccess.open(filepath, FileAccess.READ)
		var save_json = save_game.get_line()
		
		event_tree = JSON.parse_string(save_json)

#Getters and setters intended for transfering trees between saves
func set_event_tree(tree: Dictionary) -> void:
	event_tree = tree
	

func get_event_tree() -> Dictionary:
	return event_tree
	
func _does_player(path: Array[String]) -> bool:
	var current = event_tree
	
	for key in path:
		current = current.get(key)
		if current == null:
			return false
			
	return true

#_did _player is an alias for _does_player
func _did_player(path: Array[String]) -> bool:
	return _does_player(path)
	
func _make_player(path: Array[String]) -> void:
	var current = event_tree
	
	for key in path:
		if current.get(key) == null:
			current[key] = {}
		
		current = current[key]
		
const KNOW_NPC = "known_npcs"
const KNOW_LORE = "known_lore"
const AS_TOLD_BY = "heard_from"
const DO = "completed_actions"
	
#Use the functions below to check events easier
func has_player_met(name: String) -> bool:
	return _does_player([KNOW_NPC,name])
			
func make_player_meet(name: String) -> void:
	_make_player([KNOW_NPC,name])
	
func has_player_learnt(lore: String) -> bool:
	return _does_player([KNOW_LORE,lore])

func make_player_learn(lore: String) -> void:
	_make_player([KNOW_LORE,lore])
	
func has_player_talked_to_NPC_about_lore(npc_name: String, lore: String) -> bool:
	return _does_player([KNOW_LORE,lore,AS_TOLD_BY,npc_name])
	
func make_player_learn_lore_by_NPC(npc_name: String, lore: String) -> void:
	_make_player([KNOW_LORE,lore,AS_TOLD_BY,npc_name])
	
func has_player_done(action: String) -> bool:
	return _did_player([DO,action])

func make_player_do(action: String) -> void:
	return _make_player([DO, action])
