class_name NPC
extends Node

@export var name_on_dialogue: String
@export var portrait: AnimatedTexture
var name_in_events: String
var event_tracker: WorldEvents
var dialogue_manager: DialogueManager

func register_event_tracker(new_event_tracker: WorldEvents) -> void:
	if event_tracker != null:
		event_tracker.queue_free()
	event_tracker = new_event_tracker
	
func register_dialogue_manager(new_dialogue_manager: DialogueManager) -> void:
	if dialogue_manager != null:
		dialogue_manager.queue_free()
	dialogue_manager = new_dialogue_manager

#All interactions start and end the same, to change dialogue based on NPC change play_interaction
func interact() -> void:
	_prepare_interaction()
	await play_interaction()
	_close_interaction()
	
func _close_interaction() -> void:
	dialogue_manager.hide_dialogue()
	
func _prepare_interaction() -> void:
	dialogue_manager.set_speaker_name(name)
	dialogue_manager.set_speaker_portrait(portrait)
	
#Define custom character scripts here along utilising the methods of the eventTracker and helper functions
#and constants below
func play_interaction() -> void:
	pass
	
#Helper functions to use in play_interaction
#A sequence is a function causes the NPC to interact with the player
#For example play_interaction is a sequence
func say(dialogue: String) -> void:
	await dialogue_manager.show_dialogue(dialogue)
	
	
func choice(choices: Array[String], sequences: Array[Callable]) -> void:
	var option = await dialogue_manager.show_choices(choices)
	
	await sequences[option].call()
	
	
func told_about(lore: String) -> bool:
	return event_tracker.has_player_talked_to_NPC_about_lore(name_in_events, lore)
	
	
func teach(lore: String) -> void:
	event_tracker.make_player_learn_lore_by_NPC(name_in_events, lore)
	
	
func introduce(not_met_before_sequence: Callable, has_met_sequence: Callable) -> void:
	if !event_tracker.has_player_met(name_in_events):
		await not_met_before_sequence.call()
		event_tracker.make_player_meet(name_in_events)
	else:
		await has_met_sequence.call()
			
			
#List of all characters that can be used in play_interaction
const CHARACTER_SAMUEL = "samuel"
const CHARACTER_JARED = "jared"
const CHARACTER_FORTUNE = "fortune"
const CHARACTER_PAUL = "paul"
const CHARACTER_JACOB = "jacob"
const CHARACTER_MAXWELL = "maxwell"
const CHARACTER_GRETEL = "gretel"
const CHARACTER_JOSH = "josh"
const CHARACTER_JOHANNA = "johanna"
const CHARACTER_AXE = "axe"

#List of all lore that can be used in play_interaction
const LORE_GIANTS_CAVE = "giants_cave"
const LORE_GIANTS_TRIAL = "giants_trial"
const LORE_FIRE_ELEMENTAL = "fire_elem"
const LORE_WATER_ELEMENTAL = "water_elem"
const LORE_AIR_ELEMENTAL = "air_elem"
const LORE_EARTH_ELEMENTAL = "earth_elem"
