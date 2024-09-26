extends Area3D

@export var processed_bodies: Array[Node] = []

func _on_itemholderarea3_body_entered(body: Node) -> void:
	if body.name == "herbsBody" and body not in processed_bodies:
		processed_bodies.append(body)
		print("Herbs!")
		if "herbsBody" not in Global.items_found:
			Global.items_found.append("herbsBody")
			check_all_items_found()
		else:
			print("already Found")



func check_all_items_found() -> void:
	if Global.all_items_found():
		print("All items found")
		Global.trigger_event()


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_itemholderarea3_body_entered"))
