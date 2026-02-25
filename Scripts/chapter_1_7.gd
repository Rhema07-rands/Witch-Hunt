extends Control

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_1_7")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/chapter_1_8_1.tscn")
	else:
		print("Not inside tree anymore!") # Replace with your actual next scene


func ITK():
	get_tree().change_scene_to_file("res://Scenes/chapter_1_8_2_1.tscn")

func coward():
	get_tree().change_scene_to_file("res://Scenes/chapter_1_7_5.tscn")
