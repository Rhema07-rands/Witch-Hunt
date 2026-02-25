extends Node2D
@onready var camera: AnimationPlayer = $Witch/Camera2D/camera
@onready var controls: CanvasLayer = $Controls
@onready var c_iircle: Label = $"CanvasLayer Fake/CIircle"
@onready var slime_spirit: Label = $"CanvasLayer Fake/Slime Spirit"
@onready var slime_spirit_2: AnimatedSprite2D = $"CanvasLayer Fake/Slime Spirit2"

@export var level_name := "stage4"
@export var next_level_name := "stage5"

@onready var what: Label = $"CanvasLayer Fake/Pause Menu Screen/WHAT"
var random_text = ["Ok? What Is It?", "Is There Something You're Longing For?", "But Why Pause Tho?", "Wrap It Up Bro, You're Trash"]
signal level_completed(level_name: String)
@onready var pause_manu_animation: AnimationPlayer = $"CanvasLayer Fake/Pause Menu Screen/pause manu animation"
@onready var pause_menu_screen: Node2D = $"CanvasLayer Fake/Pause Menu Screen"
var pick = random_text.pick_random()

func _ready() -> void:
	SaveManager.save_progress()
	pause_menu_screen.hide()
	what.text = pick
	c_iircle.show()
	slime_spirit.show()
	slime_spirit_2.show()
	controls.hide()
	camera.play("cutscene")
	await camera.animation_finished
	controls.show()
	c_iircle.hide()
	slime_spirit.hide()
	slime_spirit_2.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		SaveManager.mark_level_complete(level_name)
		SaveManager.save_progress()
		emit_signal("level_completed", level_name)
		# Optional: Go back to level selector or next level
		call_deferred("go_to_next_scene")

func go_to_next_scene():
	print("Changing to next scene...")
	if is_inside_tree():
		get_tree().change_scene_to_file("res://Scenes/victory_screen_3.tscn")
	else:
		print("Not inside tree anymore!") 

func _on_pause_menu_pressed() -> void:
	get_tree().paused = true
	pause_manu_animation.play("Slide_up")
	pause_menu_screen.show()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_level_selector_pressed() -> void:
	get_tree().paused = false
	SaveManager.save_progress()
	get_tree().change_scene_to_file("res://Scenes/black_screen_null.tscn")


func _on_continue_pressed() -> void:
	get_tree().paused = false
	pause_manu_animation.play_backwards("Slide_up")
	await pause_manu_animation.animation_finished
	pause_menu_screen.hide()
