extends VBoxContainer

const WORLD = preload("res://Map/world.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(WORLD)



func _on_quit_pressed() -> void:
	get_tree().quit()
