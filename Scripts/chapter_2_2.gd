extends Control
@onready var walker: AnimationPlayer = $Witch/walker
@onready var witch: AnimatedSprite2D = $Witch
@onready var camera: AnimationPlayer = $Camera2D/camera

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_2_2")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/chapter_2_3.tscn")
	else:
		print("Not inside tree anymore!")  # Replace with your actual next scene

@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)

func fight():
	get_tree().change_scene_to_file("res://Scenes/chapter_2_2_5.tscn")

func play_first_animation():
	walker.play("move_forward")
	witch.play("walk")
	await witch.animation_finished
	witch.play("idle")
	camera.play("camera_move")
	await camera.animation_finished
	await get_tree().create_timer(2.0).timeout
	camera.play_backwards("camera_move")
