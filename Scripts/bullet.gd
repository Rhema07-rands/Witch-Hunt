extends Area2D

@export var speed := 700
var direction = Vector2.RIGHT

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	position += direction * speed * delta


# In Bullet.gd
func _on_body_entered(body):
	if body.name == "Witch":
		body.take_damage(5)
		var knockback_direction = (body.global_position - global_position).normalized()
		body.apply_knockback(knockback_direction * 100)
		queue_free()
