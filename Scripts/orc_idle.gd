extends OrcState

@onready var enemy = get_parent().get_parent()
@export var gravity := 980.0
@onready var attack_area_collision_3: CollisionShape2D = $"../../AttackHitbox/Attack Area Collision3"
@onready var attack_area_collision_4: CollisionShape2D = $"../../AttackHitbox/Attack Area Collision4"

func enter():
	enemy.animated_sprite.play("idle")
	attack_area_collision_3.call_deferred("set_disabled", true)
	attack_area_collision_4.call_deferred("set_disabled", true)

func _physics_process(delta):
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.velocity.x = 0
