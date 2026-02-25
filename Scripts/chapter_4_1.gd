extends Control
@onready var witch: AnimatedSprite2D = $Witch
@onready var walker: AnimationPlayer = $Witch/walker
@onready var slime_spirit: AnimatedSprite2D = $"Slime Spirit"
@onready var spawn: AnimationPlayer = $"Slime Spirit/spawn"

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_4_1")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/black_screen3.tscn")
	else:
		print("Not inside tree anymore!")  # Replace with your actual next scene

func play_first_animation():
	walker.play("walk")
	witch.play("walk")
	await witch.animation_finished
	witch.play("idle")

func play_second_animation():
	spawn.play("spawn")
	slime_spirit.show()
	slime_spirit.play_backwards("death")
	await slime_spirit.animation_finished
	slime_spirit.play("idle")

func play_third_animation():
	slime_spirit.play("death")
	spawn.play_backwards("spawn")
	await spawn.animation_finished

@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
