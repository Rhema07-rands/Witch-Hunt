extends FinalBossState

@onready var enemy = get_parent().get_parent()
@export var gravity := 980.0
@onready var main_body_1: CollisionShape2D = $"../../Main Body 1"


func enter():
	enemy.animated_sprite.play("idle")
	main_body_1.call_deferred("set_disabled", false)



func _physics_process(delta):
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.velocity.x = 0
