extends State
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

func enter_state(player_node):
	super(player_node)
	player.velocity = Vector2.ZERO
	player.play_animation("Death")
	player.play_sec_animation("null")
	await player.get_tree().create_timer(2.0).timeout
	player._on_died()
