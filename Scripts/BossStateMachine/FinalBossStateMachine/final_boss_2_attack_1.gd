extends FinalBossState
@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var boss = get_parent().get_parent()
@export var gravity := 980.0
@export var red_circle_scene: PackedScene = preload("res://Scenes/red_attack_circle.tscn")
@onready var collision_shape_2d: CollisionShape2D = $"../../Blast_2 Hitbox/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Blast_2 Hitbox/CollisionShape2D2"
@onready var main_body_2: CollisionShape2D = $"../../Main Body 2"
@onready var main_body_1: CollisionShape2D = $"../../Main Body 1"
@onready var main_body_3: CollisionShape2D = $"../../Main Body 3"

var has_spawned := false

func enter():
	boss.velocity = Vector2.ZERO
	animated_sprite.play("attack_1")
	has_spawned = false
	collision_shape_2d.call_deferred("set_disabled", true)
	collision_shape_2d_2.call_deferred("set_disabled", true)

	main_body_3.call_deferred("set_disabled", true)
	main_body_2.call_deferred("set_disabled", true)
	main_body_1.call_deferred("set_disabled", false)
	if not animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.connect(_on_animated_sprite_2d_frame_changed)

func exit():
	has_spawned = false
	if animated_sprite.frame_changed.is_connected(_on_animated_sprite_2d_frame_changed):
		animated_sprite.frame_changed.disconnect(_on_animated_sprite_2d_frame_changed)

func _physics_process(delta):
	if boss.player:
		var distance_to_player = boss.global_position.distance_to(boss.player.global_position)
		if distance_to_player:
			var direction_to_player = boss.player.global_position.x - boss.global_position.x
			boss.animated_sprite.flip_h = direction_to_player < 0
	if not boss.is_on_floor():
		boss.velocity.y += gravity * delta
	else:
		boss.velocity.y = 0

	boss.move_and_slide()

func _spawn_red_circle():
	if boss.player:
		var circle = red_circle_scene.instantiate()
		circle.global_position = boss.player.global_position
		boss.get_tree().current_scene.add_child(circle)

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "attack_1":
		var current_frame = animated_sprite.frame
		if current_frame == 5:
			_spawn_red_circle()
			has_spawned = true
