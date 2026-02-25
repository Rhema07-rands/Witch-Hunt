extends FinalBossState

@onready var boss = get_parent().get_parent()
@onready var slash_shape: CollisionShape2D = $"../../SlashHitbox/SlashShape"
@onready var collision_shape_2d: CollisionShape2D = $"../../Dash Detection Area/CollisionShape2D"


@export var dash_speed := 600.0
@export var gravity := 980.0

var direction_to_player := 1
var is_dashing := false

func enter():
	
	boss.animated_sprite.play("dash_attack")
	is_dashing = true

	# Disable both hitboxes at start


	# Connect the animation finished signal once
	if not boss.animated_sprite.animation_finished.is_connected(_on_dash_animation_finished):
		boss.animated_sprite.animation_finished.connect(_on_dash_animation_finished)

func exit():
	boss.velocity = Vector2.ZERO
	is_dashing = false
	

	if boss.animated_sprite.animation_finished.is_connected(_on_dash_animation_finished):
		boss.animated_sprite.animation_finished.disconnect(_on_dash_animation_finished)

func _physics_process(delta):
	if boss.player:
		direction_to_player = sign(boss.player.global_position.x - boss.global_position.x)
		boss.animated_sprite.flip_h = direction_to_player < 0

	boss.velocity = Vector2.ZERO
	if not is_dashing:
		return

	# Apply gravity
	if not boss.is_on_floor():
		boss.velocity.y += gravity * delta
	else:
		boss.velocity.y = 0

	# Move horizontally toward the player
	boss.velocity.x = direction_to_player * dash_speed
	boss.move_and_slide()

	# Hitbox timing (based on animation frame)
func _on_dash_animation_finished():
	is_dashing = false
	boss.final_boss_1_state_machine.change_state("FinalBossAttack")
	
	# If the player is still in attack area, enter attack state
