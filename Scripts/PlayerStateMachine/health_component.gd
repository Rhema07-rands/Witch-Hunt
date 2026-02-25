extends Node
class_name HealthComponentFinalStage

signal health_depleted
signal hit
signal health_changed(new_health)

@export var max_health := 300
var current_health := max_health

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health)
	if current_health > 0:
		emit_signal("hit")
		
		
	if current_health <= 0:
		emit_signal("health_depleted")
		
