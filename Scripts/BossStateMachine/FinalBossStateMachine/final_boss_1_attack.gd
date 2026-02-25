extends FinalBossState

@onready var animated_sprite: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var collision_shape_2d: CollisionShape2D = $"../../Attack HitBox/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../../Attack HitBox/CollisionShape2D2"
@onready var collision_polygon_2d: CollisionShape2D = $"../../Attack HitBox/CollisionPolygon2D"
@onready var collision_polygon_2d_2: CollisionShape2D = $"../../Attack HitBox/CollisionPolygon2D2"
@onready var dash_detection_area: Area2D = $"../../Dash Detection Area"

@onready var boss = get_parent().get_parent()
@onready var collision_shape: CollisionShape2D = $"../../Dash Detection Area/CollisionShape2D"




func enter():
	boss.animated_sprite.play("attack")
	boss.velocity = Vector2.ZERO
	dash_detection_area.set_deferred("monitoring",false)
	collision_shape.call_deferred("set_disabled", true)

func exit():
	dash_detection_area.set_deferred("monitoring", true)
	collision_shape.call_deferred("set_disabled", false)
	boss.velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	boss.velocity.x = 0
	
	
	if not boss.is_on_floor():
		boss.velocity.y += boss.gravity * delta
	else:
		boss.velocity.y = 0
	boss.move_and_slide()


func _on_attack_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(20)
		print ("player hit -20")


func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation == "attack":
		var current_frame = animated_sprite.frame
		if current_frame == 4:
			collision_shape_2d.call_deferred("set_disabled", false)
			collision_shape_2d_2.call_deferred("set_disabled", false)
		else:
			collision_shape_2d.call_deferred("set_disabled", true)
			collision_shape_2d_2.call_deferred("set_disabled", true)
		if current_frame == 8:
			collision_polygon_2d.call_deferred("set_disabled", false)
			collision_polygon_2d_2.call_deferred("set_disabled", false)
		else:
			collision_polygon_2d.call_deferred("set_disabled", true)
			collision_polygon_2d_2.call_deferred("set_disabled", true)
