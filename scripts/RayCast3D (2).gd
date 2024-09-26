extends RayCast3D

@onready var prompt = $Prompt


func _ready():
	
	set_collision_mask_value(1, true) # Enable collision with layer 1

func _process(_delta):
	if is_colliding():
		var hitObj = get_collider()
		if hitObj and hitObj is Interactable and StaticBody3D:
			prompt.text = hitObj.get_prompt()
			if Input.is_action_just_pressed("interact"):
				hitObj.interact()
				prompt.text = ""
		else:
			prompt.text = ""  # Clear the prompt when not colliding
		if hitObj is RigidBody3D:
			prompt.text = "+"
			
		if hitObj is Itemholder:
			prompt.text = "To spill blood"
			
		if hitObj is Pedastil:
			prompt.text = "Power of knowledge"
			
		if hitObj is Wineholder:
			prompt.text = "Lose all ambitions"
		
		if hitObj is Boneholder:
			prompt.text = "From the grave"
			
		if hitObj is Herbholder:
			prompt.text = "Natures flavor"
		
	else:
		prompt.text = ""




func interact():
	var hitObj = get_collider()
	if hitObj and hitObj is Interactable:
		hitObj.interact()
		prompt.text = ""
