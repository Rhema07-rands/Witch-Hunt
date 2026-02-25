extends Control
@onready var witch: AnimatedSprite2D = $Witch

@export var dialogue_file: DialogueResource
@onready var goblin: AnimatedSprite2D = $Goblin
@onready var walking: AnimationPlayer = $Goblin/walking
@onready var walker: AnimationPlayer = $Witch/walker

func _ready():
	await get_tree().create_timer(2.0).timeout
	DialogueManager.show_dialogue_balloon(dialogue_file, "Chapter_1_8_2_5")
	if not DialogueManager.dialogue_ended.is_connected(_on_dialogue_ended):
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(conversation_name):
	print("Dialogue ended:", conversation_name)
	call_deferred("_go_to_next_scene")

func _go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/black_screen15.tscn")
	else:
		print("Not inside tree anymore!")

func play_first_animation():
	goblin.play("walk")
	walking.play("walk_forward")
	await walking.animation_finished
	goblin.play("idle")

func play_second_animation():
	await get_tree().create_timer(2.0).timeout
	witch.hide()
	walker.play("Flash_Step")
	await walker.animation_finished
	witch.show()
	witch.play("idle")
	await get_tree().create_timer(2.0).timeout
	goblin.flip_h = true
	goblin.play("attack")
	await get_tree().create_timer(1.0).timeout
	witch.play("hurt")
	await goblin.animation_finished
	goblin.play("idle")
 
func play_third_animation():
	witch.play("Death")
	
func Return():
	get_tree().reload_current_scene()
