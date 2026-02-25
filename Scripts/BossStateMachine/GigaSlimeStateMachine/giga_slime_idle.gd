extends GigaSlimeState

@onready var enemy = get_parent().get_parent()
@export var gravity := 980.0
@onready var attack_area_collision: CollisionShape2D = $"../../Attack Hitbox/Attack Area Collision"
@onready var attack_area_collision_3: CollisionShape2D = $"../../Attack Hitbox2/Attack Area Collision"
@onready var attack_area_collision_4: CollisionShape2D = $"../../Attack Hitbox2/Attack Area Collision2"
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D2"
@onready var collision_shape_2d_4: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D4"
@onready var collision_shape_2d_5: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D5"
@onready var collision_shape_2d_7: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D7"
func enter():
	enemy.animated_sprite.play("idle")
	attack_area_collision.call_deferred("set_disabled", true)
	attack_area_collision_3.call_deferred("set_disabled", true)
	attack_area_collision_4.call_deferred("set_disabled", true)
	collision_shape_2d_4.call_deferred("set_disabled", true)
	collision_shape_2d_5.call_deferred("set_disabled", true)
	if enemy.animated_sprite.flip_h:
		collision_shape_2d_5.call_deferred("set_disabled", false)
		collision_shape_2d_7.call_deferred("set_disabled", false)
		collision_shape_2d.call_deferred("set_disabled", true)
		collision_shape_2d_2.call_deferred("set_disabled", true)
	else:
		collision_shape_2d.call_deferred("set_disabled", false)
		collision_shape_2d_2.call_deferred("set_disabled", false)
		collision_shape_2d_5.call_deferred("set_disabled", true)
		collision_shape_2d_7.call_deferred("set_disabled", true)

func _physics_process(delta):
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.velocity.x = 0


func _on_attack_hitbox_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(5)
		print ("player hit -5")
