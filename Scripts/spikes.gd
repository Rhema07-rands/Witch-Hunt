extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Witch" or body.name == "Orc":
		body.take_damage(5)
		body.velocity.y = -400
