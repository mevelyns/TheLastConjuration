
extends StaticBody3D


@export var prompt_message: String = "Interact"
@export var prompt_action: String = "interact"

func get_prompt() -> String:
	var key_name: String = ""
	var action_list = InputMap.action_get_events(prompt_action)
	for action in action_list:
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[" + key_name + "]"

