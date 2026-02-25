extends OrcState

@onready var enemy = get_parent().get_parent()

func enter():
	enemy.is_dead =true
	enemy.animated_sprite.play("death")
	enemy.velocity = Vector2.ZERO
	await enemy.animated_sprite.animation_finished
	print("Orc Died")
	enemy.dead()
