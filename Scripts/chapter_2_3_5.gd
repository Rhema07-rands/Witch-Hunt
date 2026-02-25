extends Control
@onready var witch: AnimatedSprite2D = $Witch

@export var dialogue_file: DialogueResource

func _ready():
	witch.play("idle")
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_2_3_5")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/chapter_2_4.tscn")
	else:
		print("Not inside tree anymore!")  # Replace with your actual next scene

func play_animation():
	witch.play("charge")

@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
