extends StaticBody2D


func _on_final_boss_2_tree_exited() -> void:
	get_tree().quit()


func _on_witch_tree_exited() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		body.take_damage(1000)
		print ("player got owned")
