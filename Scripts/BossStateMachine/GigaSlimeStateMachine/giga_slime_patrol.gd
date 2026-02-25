extends GigaSlimeState

@onready var enemy = get_parent().get_parent()
@export var patrol_speed := 50.0
@export var gravity := 980.0

var patrol_target : Vector2

func enter():
	enemy.animated_sprite.play("chase")
	patrol_target = enemy.get_node("PatrolPointRight").global_position
	
func _physics_process(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
	else: 
		enemy.velocity.y = 0

#patrol logic
	var direction = sign(patrol_target.x - enemy.global_positon.x)
	enemy.velocity.x = direction * patrol_speed
	
	enemy.animated_sprite.flip_h = direction < 0
	enemy.move_and_slide()

	if enemy.global_position.distance_to(patrol_target) < 10.0:
		if patrol_target == enemy.get_node("PatrolPointRight").global_position:
			patrol_target = enemy.get_node("PatrolPointLeft").global_position
		else: 
			patrol_target = enemy.get_node("PatrolPointRight").global_position
