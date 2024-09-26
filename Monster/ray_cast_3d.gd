extends RayCast3D


func _ready():
	
	set_collision_mask_value(1, true) # Enable collision with layer 1

func _process(_delta):
	if is_colliding():
		var hitObj = get_collider()
		if hitObj and hitObj is Interactable and StaticBody3D:
				hitObj.interact()
		

func interact():
	var hitObj = get_collider()
	if hitObj and hitObj is Interactable:
		hitObj.interact()
