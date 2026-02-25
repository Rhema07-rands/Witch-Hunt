extends Node
@onready var level_select_screen_joystick: Control = $CanvasLayer/level_select_screen_joystick
@onready var camera_body: CharacterBody2D = $Camera_Body
@onready var fade_to_black: AnimationPlayer = $Fade_to_black
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var completed: Label = $COMPLETED
@onready var completed_2: Label = $COMPLETED2
@onready var completed_3: Label = $COMPLETED3
@onready var camera: AnimationPlayer = $Camera_Body/Camera2D/camera
@onready var completed_4: Label = $COMPLETED4
@onready var camera_2d: Camera2D = $Camera_Body/Camera2D
@onready var completed_5: Label = $COMPLETED5
@onready var stage_buttons = {
	"stage1": $Stage1,
	"stage2": $Stage2,
	"stage3": $Stage3,
	"stage4": $Stage4,
	"stage5": $Stage5
}

func _ready():
	if not SaveManager.level_select_intro_played:
		cutscene()
		SaveManager.level_select_intro_played = true
		SaveManager.save_progress()
	else:
		camera_2d.position = Vector2(0, 0)
	update_level_access()
	SaveManager.save_progress()
	SaveManager.load_player_position()
	completed_label()
	

func update_level_access():
	var unlocked = ["stage1"]  # Stage1 is always unlocked
	
	for i in range(1, 5):
		var prev_stage = "stage%d" % i
		var next_stage = "stage%d" % (i + 1)
		if SaveManager.is_level_complete(prev_stage):
			unlocked.append(next_stage)
	
	for stage_name in stage_buttons.keys():
		var button = stage_buttons[stage_name]
		button.disabled = not unlocked.has(stage_name)

func _on_stage_1_pressed() -> void:
	SaveManager.save_progress()
	SaveManager.save_player_position(camera_body.global_position)
	fade_to_black.play("Fadw_to_black_1")
	await fade_to_black.animation_finished
	canvas_layer.hide()
	get_tree().change_scene_to_file("res://Scenes/black_screen_intro.tscn")


func _on_stage_2_pressed() -> void:
	SaveManager.save_progress()
	SaveManager.save_player_position(camera_body.global_position)
	fade_to_black.play("Fadw_to_black_1")
	await fade_to_black.animation_finished
	canvas_layer.hide()
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/black_screen_intro_1.tscn")


func _on_stage_3_pressed() -> void:
	SaveManager.save_progress()
	SaveManager.save_player_position(camera_body.global_position)
	fade_to_black.play("Fadw_to_black_1")
	await fade_to_black.animation_finished
	canvas_layer.hide()
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/black_screen_intro_2.tscn")


func _on_stage_4_pressed() -> void:
	SaveManager.save_progress()
	SaveManager.save_player_position(camera_body.global_position)
	fade_to_black.play("Fadw_to_black_1")
	await fade_to_black.animation_finished
	canvas_layer.hide()
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/black_screen_intro_3.tscn")


func _on_stage_5_pressed() -> void:
	SaveManager.save_progress()
	SaveManager.save_player_position(camera_body.global_position)
	fade_to_black.play("Fadw_to_black_1")
	await fade_to_black.animation_finished
	canvas_layer.hide()
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/black_screen_intro_4.tscn")

func completed_label():
	if SaveManager.is_level_complete("stage1"):
		completed.show()
	else:
		completed.hide()

	if SaveManager.is_level_complete("stage2"):
		completed_2.show()
	else:
		completed_2.hide()

	if SaveManager.is_level_complete("stage3"):
		completed_3.show()
	else:
		completed_3.hide()

	if SaveManager.is_level_complete("stage4"):
		completed_4.show()
	else:
		completed_4.hide()

	if SaveManager.is_level_complete("stage5"):
		completed_5.show()
	else:
		completed_5.hide()

func cutscene():
	canvas_layer.hide()
	fade_to_black.play("Fade_to_black")
	await fade_to_black.animation_finished
	camera.play("slide_show")
	await camera.animation_finished
	canvas_layer.show()
