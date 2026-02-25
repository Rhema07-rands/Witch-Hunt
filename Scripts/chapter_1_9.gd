extends Control

@export var dialogue_file: DialogueResource
@onready var witch: AnimatedSprite2D = $Witch

func _ready():
	witch.play("idle")
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_1_9")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_conversation_name):
	witch.play("Death")
	await witch.animation_finished
	get_tree().change_scene_to_file("res://Scenes/victory_screen.tscn")  # Replace with your actual next scene

func play_first_animation():
	witch.play("charge")


@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
