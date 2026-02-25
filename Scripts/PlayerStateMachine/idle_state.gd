extends State
@onready var damage_collision_hurtbox_2: CollisionShape2D = $"../Attack collision Box/Damage Collision Hurtbox2"
@onready var damage_collision_hurtbox: CollisionShape2D = $"../Attack collision Box/Damage Collision Hurtbox"
@onready var area_of_effect_collision: CollisionShape2D = $"../Attack collision Box/Area Of Effect Collision"
@onready var charge: AnimatedSprite2D = $"../Charge"

@onready var witch_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

func enter_state(player_node):
	super(player_node)
	player.velocity.x = 0
	player.play_animation("idle")
	player.play_sec_animation("null")
	area_of_effect_collision.disabled = true


	damage_collision_hurtbox.disabled = true

	damage_collision_hurtbox_2.disabled = true

func handle_input(_delta):
	if Input.is_action_just_pressed("jump") and player.coyote_timer > 0:
		player.change_state("JumpState")
	elif Input.get_axis("left", "right") != 0:
		player.change_state("WalkState")

	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")

	elif Input.is_action_just_pressed("attack"):
		player.change_state("AttackState")
	elif Input.is_action_just_pressed("charge"):
		player.change_state("AOEAttackState")
