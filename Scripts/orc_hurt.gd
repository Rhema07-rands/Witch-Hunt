extends OrcState
@onready var enemy = get_parent().get_parent()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func enter():
	enemy.animated_sprite.play("hurt")
	await enemy.animated_sprite.animation_finished
	
	enemy.orc_state_machine.change_state("OrcAttack")
	
func _physics_process(delta: float) -> void:
	enemy.velocity.x = 0
	
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	enemy.move_and_slide()
