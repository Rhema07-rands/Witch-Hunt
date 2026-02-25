extends GigaSlimeState
@onready var enemy = get_parent().get_parent()
@onready var attack_area_collision: CollisionShape2D = $"../../Attack Hitbox2/Attack Area Collision"
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var attack_area_collision_2: CollisionShape2D = $"../../Attack Hitbox2/Attack Area Collision2"
@onready var attack_hitboxd: Area2D = $"../../Attack Hitbox2"


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func enter():
	
	animated_sprite.play("counter_attack")
	enemy.velocity = Vector2.ZERO
	await animated_sprite.animation_finished
	enemy.giga_slime_state_machine.change_state("GigaSlimeAttack")


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
		if current_frame == 3 or current_frame == 4:
			attack_area_collision.call_deferred("set_disabled", false)
			attack_area_collision_2.call_deferred("set_disabled", false)
		else:
			attack_area_collision.call_deferred("set_disabled", true)
			attack_area_collision_2.call_deferred("set_disabled", true)


func _on_attack_hitbox_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(15)
		print ("player hit -15")
