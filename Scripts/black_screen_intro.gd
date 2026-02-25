extends Control

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "start")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	SaveManager.save_progress()

func _on_dialogue_ended(_conversation_name):
	get_tree().change_scene_to_file("res://Scenes/chapter_1.tscn")
	SaveManager.save_progress()# Replace with your actual next scene
