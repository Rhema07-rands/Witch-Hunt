extends State

func enter_state(player_node):
	super(player_node)
	player.velocity.y = player.JUMP_VELOCITY
	player.play_animation("jump")
	player.play_sec_animation("null")
	player.coyote_timer = 0.0

func handle_input(_delta):
	if player.is_on_floor():
		player.change_state("IdleState")
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
	elif Input.get_axis("left", "right") != 0:
		player.change_state("WalkState")
	elif Input.is_action_just_pressed("charge"):
		player.change_state("AOEAttackState")
