extends FinalBossState

@onready var enemy = get_parent().get_parent()
@export var chase_speed := 50.0
@export var stop_distance := 70.0  # Distance to stop in front of the player
@export var gravity := 980.0
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack HitBox/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack HitBox/CollisionShape2D2"
@onready var collision_polygon_2d: CollisionShape2D = $"../../Attack HitBox/CollisionPolygon2D"
@onready var collision_polygon_2d_2: CollisionShape2D = $"../../Attack HitBox/CollisionPolygon2D2"
@onready var slash_shape: CollisionShape2D = $"../../SlashHitbox/SlashShape"
@onready var dash_detection_area: Area2D = $"../../Dash Detection Area"

func enter():
	enemy.animated_sprite.play("run")
	collision_shape_2d.call_deferred("set_disabled", true)
	collision_polygon_2d.call_deferred("set_disabled", true)
	collision_shape_2d_2.call_deferred("set_disabled", true)
	collision_polygon_2d_2.call_deferred("set_disabled", true)
	slash_shape.call_deferred("set_disabled", true)
	
func exit():
	enemy.velocity = Vector2.ZERO

func _physics_process(delta):
	
	if enemy.player and dash_detection_area.monitoring:
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
