extends Control
@onready var slime_spirit: AnimatedSprite2D = $"Slime Spirit"
@onready var witch: AnimatedSprite2D = $Witch
@onready var square_up: AnimationPlayer = $Witch/Square_up

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_2_3")
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


func play_first_animation():
	square_up.play("square_up")
	witch.play("walk")
	await witch.animation_finished
	witch.play("idle")

func play_second_animation():
	slime_spirit.flip_h = true

func play_third_animation():
	witch.play("charge")

func play_fourth_animation():
	slime_spirit.play("death")
	await slime_spirit.animation_finished
	slime_spirit.hide()

func play_fifth_animation():
	witch.play("idle")

func play_sixth_animation():
	square_up.play("slight_step")
	slime_spirit.play("attack")


@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
