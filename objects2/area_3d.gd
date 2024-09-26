extends Area3D

var toggle = false
var interactable = true
@export var animation_player: AnimationPlayer

func interact():
	if interactable:
		interactable = false
		animation_player.play("show")
		var animation_length = animation_player.get_animation_length("show")
		await get_tree().create_timer(animation_length, false).timeout
		interactable = true
