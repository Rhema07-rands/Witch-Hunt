extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var head = $AnimatedSprite2D/Head
@onready var fire_point = $FirePoint
@onready var detection_area = $DetectionArea
@onready var head_hitbox = $HeadHitbox
@onready var health_component:HealthComponent1 = $HealthComponent
@onready var health_bar = $"CannonHealthBar UI/CannonHealthBar"
var is_dead: bool = false
var player: Node2D = null
var fire_cooldown = 1.5
var fire_timer = 0.0

func _ready():
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	head_hitbox.body_entered.connect(_on_head_hitbox_entered)
	health_component.health_changed.connect(update_health_bar)
	health_component.died.connect(_on_death)
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.health

func update_health_bar(current_health):
	health_bar.value = current_health

func _on_detection_area_body_entered(body):
	if is_dead:
		return
	if body.name == "Witch":
		player = body

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
		sprite.play("idle")

func _on_head_hitbox_entered(body):
	if body.name == "Witch" and body.velocity.y > 0:
		health_component.take_damage(3)
		body.velocity.y = -300  # Bounce effect
		sprite.play("hurt")

func _process(delta):
	if player:
		_aim_at_player()
		fire_timer -= delta
		if fire_timer <= 0:
			fire_timer = fire_cooldown
			_fire()

func _aim_at_player():
	var _dir = (player.global_position - head.global_position).normalized()
	head.look_at(player.global_position)

func _fire():
	sprite.play("firing")
	var bullet = preload("res://Scenes/bullet.tscn").instantiate()
	bullet.global_position = fire_point.global_position
	bullet.direction = (player.global_position - fire_point.global_position).normalized()
	get_tree().current_scene.add_child(bullet)

func _on_death():
	is_dead = true
	sprite.play("death")
	set_physics_process(false)
	await sprite.animation_finished
	queue_free()
