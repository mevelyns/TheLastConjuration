extends Control

var is_pased = false

func _ready():
	self.visible = false 

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		
		if is_paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.visible = is_paused
		
	if event.is_action("unpause"):
		if is_paused:
			_on_resume_pressed()
		
	



var is_paused = false : 
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused

func _on_resume_pressed():
	self.is_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_Quitbtn_pressed():
	get_tree().quit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if is_paused:
			if event.button_index == MOUSE_BUTTON_LEFT:
				var resume_button = $CenterContainer/VBoxContainer/resume
				var quit_button = $CenterContainer/VBoxContainer/Quitbtn
				
				if resume_button and resume_button.get_global_rect().has_point(event.global_position):
					_on_resume_pressed()
				elif quit_button and quit_button.get_global_rect().has_point(event.global_position):
					_on_Quitbtn_pressed()
	
