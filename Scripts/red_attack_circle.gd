# RedAttackCircle.gd
extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	sprite.play("blast_attack_1")  # or whatever your red circle animation is called
	collision_shape_2d.call_deferred("set_disabled", true)

# Optionally add damage on player enter
func _on_body_entered(body):
	if body.name == "Witch":
		body.take_damage(30)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "blast_attack_1":
		var current_frame = sprite.frame
		if current_frame == 1 or current_frame == 3:
			collision_shape_2d.call_deferred("set_disabled", false)
		else:
			collision_shape_2d.call_deferred("set_disabled", true)
