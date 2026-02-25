extends State

const DASH_SPEED: float = 500
const DASH_DURATION: float = 0.2

var dash_timer = 0.0
@onready var witch_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func enter_state(player_node):
	super(player_node)

	var direction = Input.get_axis("left", "right")

	# Use last facing direction if input is 0
	if direction == 0:
		direction = player.last_facing_direction

	witch_sprite.flip_h = direction < 0
	player.velocity.x = direction * DASH_SPEED
	dash_timer = DASH_DURATION
	player.play_animation("dash")
	player.play_sec_animation("null")

func handle_input(delta):
	dash_timer -= delta

	if dash_timer <= 0:
		if Input.get_axis("left", "right") != 0:
			player.change_state("WalkState")
		else:
			player.change_state("IdleState")
