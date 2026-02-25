extends GigaSlimeState
@onready var enemy = get_parent().get_parent()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D2"
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var collision_shape_2d_4: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D4"
@onready var collision_shape_2d_5: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D5"
@onready var collision_shape_2d_7: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D7"
@onready var collision_shape_2d_10: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D10"
@onready var detection_area: Area2D = $"../../Detection Area"

func enter():
	enemy.animated_sprite.play("hurt")
	#detection_area.monitoring = false
	await get_tree().create_timer(0.5).timeout
	enemy.velocity = Vector2.ZERO
	enemy.giga_slime_state_machine.change_state("GigaSlimeCounter")

func exit():
	#detection_area.monitoring = true
	enemy.velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	enemy.velocity.x = 0
	
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.move_and_slide()


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "hurt":
		var current_frame = animated_sprite.frame
		if current_frame == 0 or current_frame == 1 or current_frame == 3 or current_frame == 4:
			collision_shape_2d.call_deferred("set_disabled", false)
			collision_shape_2d_2.call_deferred("set_disabled", false)
		else:
			collision_shape_2d.call_deferred("set_disabled", true)
			collision_shape_2d_2.call_deferred("set_disabled", true)



		if current_frame == 2:
			collision_shape_2d_4.call_deferred("set_disabled", false)
		else:
			collision_shape_2d_4.call_deferred("set_disabled", true)



		if animated_sprite.flip_h:
			if current_frame == 0 or current_frame == 1 or current_frame == 3 or current_frame == 4:
				collision_shape_2d_5.call_deferred("set_disabled", false)
				collision_shape_2d_7.call_deferred("set_disabled", false)
			else:
				collision_shape_2d_5.call_deferred("set_disabled", true)
				collision_shape_2d_7.call_deferred("set_disabled", true)
			
			
			if current_frame == 2:
				collision_shape_2d_10.call_deferred("set_disabled", false)
			else:
				collision_shape_2d_10.call_deferred("set_disabled", true)
