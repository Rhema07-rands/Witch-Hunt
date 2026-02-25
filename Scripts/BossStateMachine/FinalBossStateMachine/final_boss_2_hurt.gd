extends FinalBossState
@onready var enemy = get_parent().get_parent()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func enter():
	enemy.animated_sprite.play("hurt")
	
func _physics_process(delta: float) -> void:
	enemy.velocity.x = 0
	
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.move_and_slide()
