extends State

func enter_state(player_node):
	super(player_node)
	
	player.play_animation("hurt")
	player.play_sec_animation("null")
	await player.get_tree().create_timer(0.5).timeout
	player.change_state("IdleState")


func handle_input(_delta):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	elif Input.get_axis("left", "right") != 0:
		player.change_state("WalkState")

	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")

	elif Input.is_action_just_pressed("attack"):
		player.change_state("AttackState")
	elif Input.is_action_just_pressed("charge"):
		player.change_state("AOEAttackState")
