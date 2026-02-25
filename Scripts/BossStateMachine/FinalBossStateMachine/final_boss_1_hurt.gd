extends FinalBossState
@onready var enemy = get_parent().get_parent()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func enter():
	enemy.animated_sprite.play("hurt")
	await get_tree().create_timer(0.5).timeout
	
	enemy.final_boss_1_state_machine.change_state("FinalBossCounter")
	
func _physics_process(delta: float) -> void:
	enemy.velocity.x = 0
	
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else:
		enemy.velocity.y = 0
	enemy.move_and_slide()
