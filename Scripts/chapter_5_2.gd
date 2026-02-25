extends Control
@onready var charge: AnimatedSprite2D = $Charge
@onready var witch: AnimatedSprite2D = $Witch
@onready var finish: AnimationPlayer = $Witch/finish
@onready var slime_spirit: AnimatedSprite2D = $"Slime Spirit"
@onready var xaphanor: AnimatedSprite2D = $Xaphanor

@export var dialogue_file: DialogueResource

func _ready():
	await get_tree().create_timer(2.5).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_5_2")
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/chapter_5_3.tscn")
	else:
		print("Not inside tree anymore!")  # Replace with your actual next scene

func play_first_animation():
	xaphanor.play("death")

func play_second_animation():
	finish.play("finish")
	witch.play("walk")
	await witch.animation_finished
	witch.play("idle")

func play_third_animation():
	witch.play("charge")

func play_fourth_animation():
	charge.play("Charge")
	await charge.animation_finished
	charge.play("shine")

func play_fifth_animation():
	xaphanor.hide()
	charge.play_backwards("Charge")
	witch.play("idle")

@export var Skip : PackedScene

func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_packed(Skip)
