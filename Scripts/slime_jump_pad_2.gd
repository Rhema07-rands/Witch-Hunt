extends StaticBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var force = -500.0


func _on_area_2d_body_entered(body):
	if body.name == "Witch":
		body.velocity.y = force
		animated_sprite_2d.play("bounce")
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("idle")
	
