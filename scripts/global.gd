extends Node

const End = preload("res://Map/EndCutscene.tscn")

@export var items_found: Array[StringName] = []

var all_items_cache = false


func all_items_found() -> bool:
	if all_items_cache:
		return true
	var required_items = ["Wine3", "herbsBody", "knifeBody", "BoneItem1", "mainBookBody"]
	for item in required_items:
		if item not in items_found:
			return false
			
	all_items_cache = true
	return true 
	
	
	
func trigger_event() -> void:
	if all_items_found():
		await get_tree().create_timer(1.0).timeout
		print("Triggering main event")
		call_deferred("deferred_trigger_event")


func deferred_trigger_event() -> void:
	get_tree().change_scene_to_packed(End)
	
