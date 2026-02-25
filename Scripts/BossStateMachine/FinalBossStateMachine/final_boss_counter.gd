extends FinalBossState
@onready var enemy = get_parent().get_parent()
@onready var slash_hitbox: Area2D = $"../../SlashHitbox"
@onready var slash_shape: CollisionShape2D = $"../../SlashHitbox/SlashShape"


@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var collision_shape: CollisionShape2D = $"../../Dash Detection Area/CollisionShape2D"
@onready var dash_detection_area: Area2D = $"../../Dash Detection Area"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func enter():
	collision_shape.call_deferred("set_disabled", true)
	dash_detection_area.set_deferred("monitoring", false)
	enemy.velocity = Vector2.ZERO
	animated_sprite.play("counter_attack")
	enemy.velocity = Vector2.ZERO
	await animated_sprite.animation_finished
	enemy.final_boss_1_state_machine.change_state("FinalBossAttack")

func exit():
	collision_shape.call_deferred("set_disabled", true)
	dash_detection_area.set_deferred("monitoring", false)

func _physics_process(delta: float) -> void:
	enemy.velocity.x = 0
	
	
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.move_and_slide()



func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "counter_attack":
		var current_frame = animated_sprite.frame
		if current_frame == 2  or current_frame == 3:
			slash_shape.call_deferred("set_disabled", false)
		else:
			slash_shape.call_deferred("set_disabled", true)
