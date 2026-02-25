extends OrcState
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"

@onready var enemy = get_parent().get_parent()
@onready var attack_hitbox = enemy.get_node("AttackHitbox")
@onready var attack_area_collision_3: CollisionShape2D = $"../../AttackHitbox/Attack Area Collision3"
@onready var attack_area_collision_4: CollisionShape2D = $"../../AttackHitbox/Attack Area Collision4"
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
	enemy.move_and_slide()


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(10)
		print ("player hit -10")


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "attack":
		var current_frame = animated_sprite.frame
		if current_frame == 6 :
			attack_area_collision_3.call_deferred("set_disabled", false)
			attack_area_collision_4.call_deferred("set_disabled", false)
		else:
			attack_area_collision_3.call_deferred("set_disabled", true)
			attack_area_collision_4.call_deferred("set_disabled", true)
