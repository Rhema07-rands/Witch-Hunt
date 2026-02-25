extends Control
@onready var witch: AnimatedSprite2D = $Witch
@onready var camera: AnimationPlayer = $Witch/Camera2D/camera
@onready var slime_spirit: AnimatedSprite2D = $"Slime Spirit"
@onready var xaphanor: AnimatedSprite2D = $Xaphanor

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_5_1")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/chapter_5_1_5.tscn")
	else:
		print("Not inside tree anymore!")  # Replace with your actual next scene

func play_first_animation():
	witch.play("charge")

func play_second_animation():
	slime_spirit.play("death")
	await slime_spirit.animation_finished
	slime_spirit.hide()

func play_fifth_animation():
	witch.pause()

func play_third_animation():
	camera.play("move")
	await get_tree().create_timer(4.5).timeout
	xaphanor.flip_h = true

func play_fourth_animation():
	witch.play("idle")
	camera.play_backwards("move")
	await camera.animation_finished

@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
