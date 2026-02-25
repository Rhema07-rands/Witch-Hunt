extends GigaSlimeState
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D2"
@onready var collision_shape_2d_4: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D4"
@onready var collision_shape_2d_5: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D5"
@onready var collision_shape_2d_7: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D7"
@onready var collision_shape_2d_10: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D10"

@onready var enemy = get_parent().get_parent()
@onready var attack_hitbox = enemy.get_node("Attack Hitbox")
@onready var attack_area_collision: CollisionShape2D = $"../../Attack Hitbox/Attack Area Collision"
@onready var attack_area_collision_2: CollisionShape2D = $"../../Attack Hitbox/Attack Area Collision2"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter():
	enemy.animated_sprite.play("attack")
	enemy.velocity = Vector2.ZERO
	attack_hitbox.monitoring = true
	

func exit():
	attack_hitbox.monitoring = false
	

func _physics_process(delta: float) -> void:
	enemy.velocity.x = 0
	
	
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.move_and_slide()


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(10)
		print ("player hit -10")


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "attack":
		var current_frame = animated_sprite.frame
		if current_frame == 0 or current_frame == 1 or current_frame == 2:
			collision_shape_2d.call_deferred("set_disabled", false)
			collision_shape_2d_2.call_deferred("set_disabled", false)
		else:
			collision_shape_2d.call_deferred("set_disabled", true)
			collision_shape_2d_2.call_deferred("set_disabled", true)




		if current_frame == 3 or current_frame == 4 or current_frame == 5 or current_frame == 6 or current_frame == 7 or current_frame == 8:
			collision_shape_2d_4.call_deferred("set_disabled", false)
		else:
			collision_shape_2d_4.call_deferred("set_disabled", true)
 



		if current_frame == 9 or current_frame == 10:
			attack_area_collision.call_deferred("set_disabled", false)
			
			collision_shape_2d_5.call_deferred("set_disabled", false)
		else:
			attack_area_collision.call_deferred("set_disabled", true)
			
			collision_shape_2d_5.call_deferred("set_disabled", true)


		if animated_sprite.flip_h:
			collision_shape_2d.call_deferred("set_disabled", true)
			if current_frame == 0 or current_frame == 1 or current_frame == 2:
				collision_shape_2d_5.call_deferred("set_disabled", false)
				collision_shape_2d_7.call_deferred("set_disabled", false)
			else:
				collision_shape_2d_5.call_deferred("set_disabled", true)
				collision_shape_2d_7.call_deferred("set_disabled", true)



			if current_frame == 3 or current_frame == 4 or current_frame == 5 or current_frame == 6 or current_frame == 7 or current_frame == 8:
				collision_shape_2d_4.call_deferred("set_disabled", false)

			else:
				collision_shape_2d_4.call_deferred("set_disabled", true)


			if current_frame == 9 or current_frame == 10:
				
				attack_area_collision_2.call_deferred("set_disabled", false)
				collision_shape_2d_10.call_deferred("set_disabled", false)
			else:
				
				attack_area_collision_2.call_deferred("set_disabled", true)
				collision_shape_2d_10.call_deferred("set_disabled", true)
