extends GigaSlimeState

@onready var enemy = get_parent().get_parent()
@export var chase_speed := 20.0
@export var gravity := 980.0
@export var stop_distance: float= 90.0
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D2"
@onready var collision_shape_2d_5: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D5"
@onready var collision_shape_2d_7: CollisionShape2D = $"../../Attack Hitbox3/CollisionShape2D7"
@onready var detection_area: Area2D = $"../../Detection Area"

func enter():
	enemy.animated_sprite.play("walk")
	collision_shape_2d.call_deferred("set_disabled", false)
	collision_shape_2d_2.call_deferred("set_disabled", false)
	collision_shape_2d_5.call_deferred("set_disabled", false)
	collision_shape_2d_7.call_deferred("set_disabled", false)

func _physics_process(delta):
	if enemy.player and detection_area.monitoring:
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
	else:
		enemy.velocity.y = 0  # Stop falling if on floor

	enemy.move_and_slide()
