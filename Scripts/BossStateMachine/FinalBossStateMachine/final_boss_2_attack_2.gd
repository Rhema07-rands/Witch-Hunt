extends FinalBossState

@onready var boss = get_parent().get_parent()
@onready var collision_shape_2d: CollisionShape2D = $"../../Blast_2 Hitbox/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Blast_2 Hitbox/CollisionShape2D2"
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var main_body_1: CollisionShape2D = $"../../Main Body 1"
@onready var main_body_2: CollisionShape2D = $"../../Main Body 2"
@onready var main_body_3: CollisionShape2D = $"../../Main Body 3" 



func enter():
	boss.velocity = Vector2.ZERO
	collision_shape_2d.call_deferred("set_disabled", true)
	collision_shape_2d_2.call_deferred("set_disabled", true)
	main_body_3.call_deferred("set_disabled", true)
	animated_sprite.play("attack_2")
	await animated_sprite.animation_finished
	animated_sprite.play("attack_3")


func _physics_process(delta: float) -> void:
	if boss.player:
		var distance_to_player = boss.global_position.distance_to(boss.player.global_position)
		if distance_to_player:
			var direction_to_player = boss.player.global_position.x - boss.global_position.x
			boss.animated_sprite.flip_h = direction_to_player < 0
	boss.velocity.x = 0
	if not boss.is_on_floor():
		boss.velocity.y += boss.gravity * delta
	else:
		boss.velocity.y = 0
	boss.move_and_slide()


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "attack_3":
		var current_frame = animated_sprite.frame

		if current_frame == 0:
			collision_shape_2d.call_deferred("set_disabled", false)
		else:
			collision_shape_2d.call_deferred("set_disabled", true)

		if current_frame == 0 or current_frame == 1 or current_frame == 2 or current_frame == 3:
			main_body_1.call_deferred("set_disabled", true)
			main_body_2.call_deferred("set_disabled", false)
		else :
			main_body_1.call_deferred("set_disabled", false)
			main_body_2.call_deferred("set_disabled", true)

		if animated_sprite.flip_h:
			main_body_2.call_deferred("set_disabled", true)
			collision_shape_2d.call_deferred("set_disabled", true)
			if current_frame == 0:
				collision_shape_2d_2.call_deferred("set_disabled", false)
			else:
				collision_shape_2d_2.call_deferred("set_disabled", true)

			if current_frame == 0 or current_frame == 1 or current_frame == 2 or current_frame == 3:
				main_body_3.call_deferred("set_disabled", false)
				main_body_1.call_deferred("set_disabled", true)
			else:
				main_body_3.call_deferred("set_disabled", true)
				main_body_1.call_deferred("set_disabled", false)
