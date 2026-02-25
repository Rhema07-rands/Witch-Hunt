extends State

@onready var witch_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

func enter_state(player_node):
	super(player_node)
	player.play_animation("walk")
	player.play_sec_animation("null")

func handle_input(_delta):
	var direction = Input.get_axis("left", "right")

	# Fix direction flipping and store last direction
	if direction > 0:
		player.last_facing_direction = 1
		witch_sprite.flip_h = false
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		player.last_facing_direction = -1
		witch_sprite.flip_h = true
		animated_sprite_2d.flip_h = true

	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.change_state("IdleState")

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
	elif Input.is_action_just_pressed("attack"):
		player.change_state("AttackState")
	elif Input.is_action_just_pressed("charge"):
		player.change_state("AOEAttackState")
