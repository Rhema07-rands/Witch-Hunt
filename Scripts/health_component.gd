extends Node
class_name HealthComponent1
signal health_changed(current_health)
signal died

@export var max_health := 20
var health: int

func _ready():
	health = max_health

func take_damage(amount):
	health -= amount
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("died")
