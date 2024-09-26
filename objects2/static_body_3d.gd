extends StaticBody3D

var toggle = false
var interactable = true
var interacted = false
@export var animation_player: AnimationPlayer

func interact():
	if interactable:
		interactable = false
		interacted = true
		toggle = !toggle
		if toggle:
			$"../AnimationPlayer".play("showtxt")
			set_process_input(true) # Enable input processing
		

func _input(event):
	if event is InputEventMouseMotion:
		# If mouse moves while the text is shown, close it
		if toggle:
			$"../AnimationPlayer".play("closetxt")
			set_process_input(false) # Disable input processing
			toggle = false
			interactable = true

		# Reset toggle when mouse movement is detected
		toggle = false

# Ensure that toggle is reset when interaction occurs again
func _on_animation_finished(animation_name):
	if animation_name == "showtxt":
		toggle = false
