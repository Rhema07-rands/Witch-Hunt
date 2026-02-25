extends FinalBossState

@onready var boss = get_parent().get_parent()

func enter():
	boss.animated_sprite.play("death")
	boss.velocity = Vector2.ZERO
	await boss.animated_sprite.animation_finished
	print("Boss Killed")

	boss.die()
