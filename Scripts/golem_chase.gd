extends OrcState
@onready var detection_area: Area2D = $"../../Detection Area"

@onready var enemy = get_parent().get_parent()
@export var chase_speed := 15.0
@export var gravity := 980.0
@export var stop_distance: float = 100.0
func enter():
	enemy.animated_sprite.play("run")

func _physics_process(delta):
	if enemy.player and detection_area.monitoring:
		# Flip sprite based on direction
		var distance_to_player = enemy.global_position.distance_to(enemy.player.global_position)
		if distance_to_player > stop_distance:
			var direction_to_player = enemy.player.global_position.x - enemy.global_position.x
			enemy.animated_sprite.flip_h = direction_to_player < 0

		# Flip sprite based on direction

		# Horizontal movement only
			var direction = sign(direction_to_player)
			enemy.velocity.x = direction * chase_speed
		else:
			enemy.velocity.x = 0

	# Apply gravity always
	if not enemy.is_on_floor():
		enemy.velocity.y += gravity * delta
# Stop falling if on floor

	enemy.move_and_slide()
