class_name Itemholder
extends StaticBody3D

@export var prompt_message: String = "Interact"

func get_prompt() -> String:
	var key_name: String = ""
	return prompt_message + "\n[" + key_name + "]"
