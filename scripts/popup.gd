extends Popup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func _input(event):
	if event.is_action_pressed("interact"):
		if is_visible():
			hide()
		else:
			show_text("This is a note")
		
func show_text(text_to_display: String):
	$Label.text = text_to_display
	show()
