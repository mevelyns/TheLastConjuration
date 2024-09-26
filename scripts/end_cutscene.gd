extends Node3D

const End = preload("res://Map/EndScene.tscn")
var animation_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player = $EndCutsceneAnimation
	
	
	play_animation()

func play_animation():
	animation_player.play("EndCutscene")
	


func _on_end_cutscene_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "EndCutscene":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_packed(End)

