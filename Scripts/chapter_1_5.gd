extends Control

@export var dialogue_file: DialogueResource
@onready var witch_twin_sister: AnimatedSprite2D = $"Witch Twin Sister"
@onready var walking: AnimationPlayer = $"Witch Twin Sister/walking"
@onready var witch: AnimatedSprite2D = $Witch
@onready var walker: AnimationPlayer = $Witch/walker

func _ready():
	await get_tree().create_timer(2.0).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_1_5")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	SaveManager.save_progress()

func _on_dialogue_ended(_conversation_name):
	get_tree().change_scene_to_file("res://Scenes/chapter_1_6.tscn")
	SaveManager.save_progress()  # Replace with your actual next scene

func play_first_animation():
	witch_twin_sister.play("walk")
	walking.play("walk_forward")
	await witch_twin_sister.animation_finished
	witch_twin_sister.play("idle")

func play_second_animation():
	witch.flip_h = true
	witch.play("walk")
	witch_twin_sister.play("walk")
	walker.play("Leave_the_scene")
	walking.play("Leave_the_scene")
	await walking.animation_finished
