extends Node2D

@onready var what: Label = $"CanvasLayer Fake/Pause Menu Screen/WHAT"
@onready var pause_menu_animation: AnimationPlayer = $"CanvasLayer Fake/Pause Menu Screen/pause manu animation"
@onready var pause_menu_screen: Node2D = $"CanvasLayer Fake/Pause Menu Screen"

var random_text = [
	"Ok? What Is It?",
	"Is There Something You're Longing For?",
	"But Why Pause Tho?",
	"Wrap It Up Bro, You're Trash"
]
var pick = random_text.pick_random()

func _ready() -> void:
	SaveManager.save_progress()
	pause_menu_screen.hide()
	what.text = pick


func _on_pause_menu_pressed() -> void:
	if not get_tree().paused:
		get_tree().paused = true
		pause_menu_animation.play("Slide_up")
		pause_menu_screen.show()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	call_deferred("_change_scene", "res://Scenes/floor_1_ITK.tscn")

func _on_level_selector_pressed() -> void:
	get_tree().paused = false
	SaveManager.save_progress()
	call_deferred("_change_scene", "res://Scenes/black_screen_null.tscn")

func _on_continue_pressed() -> void:
	get_tree().paused = false
	pause_menu_animation.play_backwards("Slide_up")
	await pause_menu_animation.animation_finished
	pause_menu_screen.hide()

func _change_scene(scene_path: String) -> void:
	if get_tree():
		get_tree().change_scene_to_file(scene_path)


func _on_cannon_2_tree_exited() -> void:
	if get_tree():
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Scenes/chapter_1_8_2_5.tscn")
