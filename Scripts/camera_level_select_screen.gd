extends CharacterBody2D

const SPEED = 300.0
const go_up = -300.0
const go_down = 300

func _ready() -> void:
	save_pos()

func _physics_process(_delta: float) -> void:
	# Add the gravity.
	# Handle jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = go_up
	if Input.is_action_just_pressed("ui_down"):
		velocity.y = go_down
	move_and_slide()

func save_pos():
	var saved_pos = SaveManager.load_player_position()
	if saved_pos != null:
		global_position = saved_pos
