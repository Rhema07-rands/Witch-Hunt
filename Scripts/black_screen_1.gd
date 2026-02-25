extends Node2D

@export var floor_2 : PackedScene

func _ready() -> void:
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_packed(floor_2)
	SaveManager.save_progress()
