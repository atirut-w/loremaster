class_name NPC
extends Node

@export var name_on_dialogue: String
@export var portrait: AnimatedTexture
var name_in_events: String
var event_tracker: WorldEvents

func register_event_tracker(new_event_tracker: WorldEvents) -> void:
	event_tracker = new_event_tracker

#All interactions start and end the same, to change dialogue based on NPC change play_interaction
func interact() -> void:
	_prepare_interaction()
	await play_interaction()
	_close_interaction()
	
func _close_interaction() -> void:
	DialogueManager.hide_dialogue()
	
func _prepare_interaction() -> void:
	DialogueManager.set_speaker_name(name_on_dialogue)
	DialogueManager.set_speaker_portrait(portrait)
	
#Define custom character scripts here along utilising the methods of the eventTracker and helper functions
#and constants below
func play_interaction() -> void:
	pass

	
#Helper functions to use in play_interaction
#A sequence is a function causes the NPC to interact with the player
#For example play_interaction is a sequence
func say(dialogue: String) -> void:
	await DialogueManager.show_dialogue(dialogue)
	
	
func choice(choices_sequence_pairs: Dictionary) -> void:
	var choices = choices_sequence_pairs.keys()
	var option = await DialogueManager.show_choices(choices)
	
	await choices_sequence_pairs[choices[option]].call()
	
	
func told_about(lore: String) -> bool:
	return event_tracker.has_player_talked_to_NPC_about_lore(name_in_events, lore)
	
	
func player_heard_of_but_not_told_about(lore: String) -> bool:
	return !told_about(lore) && event_tracker.has_player_learnt(lore)
	
func teach(lore: String) -> void:
	event_tracker.make_player_learn_lore_by_NPC(name_in_events, lore)
	
	
func trigger_event(action: String) -> void:
	event_tracker.make_player_do_action_in_front_of_npc(action, name_in_events)
	
	
func seen_event(action: String) -> bool:
	return event_tracker.has_player_done_action_in_front_of_npc(action, name_in_events)

	
func introduce(not_met_before_sequence: Callable, has_met_sequence: Callable) -> void:
	if !event_tracker.has_player_met(name_in_events):
		await not_met_before_sequence.call()
		event_tracker.make_player_meet(name_in_events)
	else:
		await has_met_sequence.call()
			

func empty_sequence():
	pass
	

#Boolean array methods to help with dialogues	
func all(bools: Array[bool]) -> bool:
	return bools.all(_identity)
	

func any(bools: Array[bool]) -> bool:
	return bools.any(_identity)


func _identity(x: Variant) -> Variant:
	return x 	
	
			
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
const LORE_GIANT = "the_giant"
const LORE_GIANTS_CAVE = "giants_cave"
const LORE_GIANTS_TRIAL = "giants_trial"
const LORE_FIRE_ELEMENTAL = "fire_elem"
const LORE_WATER_ELEMENTAL = "water_elem"
const LORE_AIR_ELEMENTAL = "air_elem"
const LORE_EARTH_ELEMENTAL = "earth_elem"

#List of fish related lore
const LORE_FISHERMANS_PERIL = "fish_fishermans_peril"
const LORE_SAND_FISH = "fish_sand_fish"
const LORE_SPIRIT_FISH = "fish_spirit_fish"

#List of events related to King Jared V
const EVENT_DOUBT_KING_JARED = "e_doubt_king_jared"
const EVENT_PRAISE_KING_JARED = "e_praise_king_jared"

#List of events related to the fishermen
const EVENT_PRETEND_TO_BE_FISHERMAN = "e_pretend_fisherman"

#List of events related to the scholars
const EVENT_SCHOLAR_APPROVAL_GIVEN = "e_scholars_approve"
