extends Node2D
var SPEED = 50
@onready var camera_2d: Camera2D = $Camera2D
@onready var sky: ParallaxBackground = $sky
@onready var animation_player: AnimationPlayer = $CanvasLayer/Mainmenu/AnimationPlayer
@onready var clouds: Node2D = $CanvasLayer/Mainmenu/clouds
@onready var pressplay_button: Label = $"CanvasLayer/Mainmenu/Pressplay Button"
@onready var start: TextureButton = $CanvasLayer/Mainmenu/Start
@onready var saved_button: Node2D = $CanvasLayer/Mainmenu/Saved_button

@onready var title_card_animation: AnimationPlayer = $"CanvasLayer/Mainmenu/Title Card/Title_card_animation"

# Called when the node enters the scene tree for the first time.
func _ready():
	clouds.hide()
	if SaveManager.has_save_data():
		start.disabled = true
		start.hide()
		await get_tree().create_timer(2.3).timeout
		saved_button.show()

	else:
		saved_button.hide()
		await get_tree().create_timer(2.3).timeout
		start.disabled = false
		start.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera_2d.position.x += SPEED * delta
	var esc_pressed = Input.is_action_just_pressed("QUIT")
	if (esc_pressed == true):
			get_tree().quit()


func _on_start_pressed():
	SaveManager.mark_level_complete("Stage1")
	SaveManager.save_progress() 
	SaveManager.load_player_position()
	clouds.show()
	sky.hide()
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")
	else:
		print("Scene tree no longer exists!")


func _on_about_pressed():
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_press_to_play_pressed() -> void:
	SaveManager.save_progress()
	title_card_animation.play("Title_card_2")
	#await title_card_animation.animation_finished
	pressplay_button.queue_free()


func _on_continue_pressed() -> void:
	SaveManager.save_progress()
	SaveManager.load_player_position()
	clouds.show()
	sky.hide()
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")
	else:
		print("Scene tree no longer exists!")


func _on_reset_pressed() -> void:
	SaveManager.delete_save_data()
	#get_tree().reload_current_scene()
	clouds.show()
	sky.hide()
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	if get_tree():
		get_tree().change_scene_to_file("res://Scenes/level_selector.tscn")
	else:
		print("Scene tree no longer exists!")
