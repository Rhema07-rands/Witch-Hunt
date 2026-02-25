extends GigaSlimeState
@onready var detection_area: Area2D = $"../../Detection Area"
@onready var attack_area: Area2D = $"../../Attack Area"
@onready var collision_shape_2d: CollisionShape2D = $"../../Detection Area/CollisionShape2D"
@onready var collision_shape: CollisionShape2D = $"../../Attack Area/CollisionShape2D"

@onready var enemy = get_parent().get_parent()

func enter():
	enemy.is_dead =true
	enemy.animated_sprite.play("death")
	enemy.velocity = Vector2.ZERO
	collision_shape_2d.disabled = true
	collision_shape.disabled = true
	detection_area.set_deferred("monitoring",false)
	attack_area.set_deferred("monitoring",false)
	await enemy.animated_sprite.animation_finished
	print("Boss Killed")
	enemy.wall.queue_free()
	enemy.queue_free()
