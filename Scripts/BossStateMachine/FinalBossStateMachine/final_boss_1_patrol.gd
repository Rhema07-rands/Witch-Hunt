extends FinalBossState

@onready var boss = get_parent().get_parent()  # Get the Final Boss node
@export var walk_speed := 25.0
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack HitBox/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack HitBox/CollisionShape2D2"
@onready var collision_polygon_2d: CollisionShape2D = $"../../Attack HitBox/CollisionPolygon2D"
@onready var collision_polygon_2d_2: CollisionShape2D = $"../../Attack HitBox/CollisionPolygon2D2"
@onready var slash_shape = $"../../SlashHitbox/SlashShape"
@onready var slash_hitbox: Area2D = $"../../SlashHitbox"

var target_position: Vector2
var move_timer := 0.0
var wait_timer := 0.0
var random_time = [2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
var is_moving := false
var patrol_radius := 800  # Patrol range from spawn point

var origin_position: Vector2

func enter():
	origin_position = boss.global_position
	_choose_new_target()
	boss.animated_sprite.play("walk")
	is_moving = true
	move_timer = random_time.pick_random()
	collision_shape_2d.call_deferred("set_disabled", true)
	collision_polygon_2d.call_deferred("set_disabled", true)
	collision_polygon_2d_2.call_deferred("set_disabled", true)
	collision_shape_2d_2.call_deferred("set_disabled", true)
	slash_shape.call_deferred("set_disabled", true)

func exit():
	boss.velocity.x = 0
	is_moving = false

func _physics_process(delta):
	if not boss.is_on_floor():
		boss.velocity.y += boss.gravity * delta
	else:
		boss.velocity.y = 0

	if is_moving:
		var direction = sign(target_position.x - boss.global_position.x)
		boss.velocity.x = direction * walk_speed
		boss.animated_sprite.flip_h = direction < 0
		move_timer -= delta
		if boss.global_position.distance_to(target_position) < 10 or move_timer <= 0:
			is_moving = false
			wait_timer = random_time.pick_random()
			boss.animated_sprite.play("idle")
	else:
		boss.velocity.x = 0
		wait_timer -= delta
		if wait_timer <= 0:
			_choose_new_target()
			is_moving = true
			move_timer = random_time.pick_random()
			boss.animated_sprite.play("walk")

	boss.move_and_slide()

func _choose_new_target():
	var offset = randf_range(-patrol_radius, patrol_radius)
	target_position = origin_position + Vector2(offset, 0)
