extends Control
var random_text = ["Good Job, Want A Cookie With That?", "Is That The Best You Can Do?", "You Call That A Playthrough?", "Tf Was That?", "Do You Play Games To Pretend To Be Smart?"]
@onready var animation_player: AnimationPlayer = $"Victory Screen/AnimationPlayer"
@onready var victory_label: Label = $"Victory Screen/Victory Label"
@onready var next_stage: TextureButton = $"Victory Screen/Next Stage"
@onready var retry: TextureButton = $"Victory Screen/Retry"
@onready var congrats: Label = $"Victory Screen/Congrats"

func _ready():
	SaveManager.save_progress()
	congrats.text = random_text.pick_random()
	animation_player.play("pop_up")


func _on_next_stage_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/black_screen_null.tscn")
	SaveManager.save_progress()
	SaveManager.save_data_to_file()
