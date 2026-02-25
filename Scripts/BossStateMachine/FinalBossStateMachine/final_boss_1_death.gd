extends FinalBossState

@onready var boss = get_parent().get_parent()
@onready var dash_detection_area: Area2D = $"../../Dash Detection Area"
@onready var attack_area: Area2D = $"../../Attack Area"

@onready var collision_shape_2d: CollisionShape2D = $"../../Dash Detection Area/CollisionShape2D"
@onready var collision_shape: CollisionShape2D = $"../../Attack Area/CollisionShape2D"

func enter():
	boss.is_dead =true
	attack_area.set_deferred("monitoring", false)
	dash_detection_area.set_deferred("monitoring", false)
	collision_shape.call_deferred("set_disabled", true)
	collision_shape_2d.call_deferred("set_disabled", true)
	boss.animated_sprite.play("death")
	boss.velocity = Vector2.ZERO
	await boss.animated_sprite.animation_finished
	print("Boss Killed")

	boss._died()
