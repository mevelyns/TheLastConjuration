extends Area3D

@export var processed_bodies: Array[Node] = []

func _on_itemholderarea2_body_entered(body: Node) -> void:
	if body.name == "BoneItem1" and body not in processed_bodies:
		print("Bone!")
		processed_bodies.append(body)
		if "BoneItem1" not in Global.items_found:
			Global.items_found.append("BoneItem1")
			check_all_items_found()
		else: 
			print("already Found")


func check_all_items_found() -> void:
	if Global.all_items_found():
		print("All items found")
		Global.trigger_event()


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_itemholderarea2_body_entered"))
