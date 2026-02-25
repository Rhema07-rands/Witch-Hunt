extends Control

@export var dialogue_file: DialogueResource
@onready var witch: AnimatedSprite2D = $Witch

func _ready():
	witch.play("charge")
	await witch.animation_finished
	witch.play("idle")
	await get_tree().create_timer(2.0).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_1_3")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	SaveManager.save_progress()

func _on_dialogue_ended(_conversation_name):
	get_tree().change_scene_to_file("res://Scenes/chapter_1_4.tscn")
	SaveManager.save_progress()  # Replace with your actual next scene


@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
