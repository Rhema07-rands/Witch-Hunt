extends Control

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.0).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_1_4")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	SaveManager.save_progress()

func _on_dialogue_ended(_conversation_name):
	get_tree().change_scene_to_file("res://Scenes/chapter_1_5.tscn") 
	SaveManager.save_progress() # Replace with your actual next scene
