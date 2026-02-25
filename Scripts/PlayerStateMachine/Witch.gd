extends CharacterBody2D
const  SPEED = 90.0
const JUMP_VELOCITY = -295.0
var current_state
var last_facing_direction := 1
@onready var witch_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: HealthComponent = $HealthComponent
@onready var witch_health_bar: ProgressBar = $WitchHealthBar/WitchHealthBar
#var velocity = Vector2.ZERO
var coyote_time := 0.5
var coyote_timer := 0.0
var knockback_timer = 0.0
@onready var camera: Camera2D = $Camera2D
@onready var charge: AnimatedSprite2D = $Charge
@onready var joystick := $"../Controls/VirtualJoystick"
func _ready():
	change_state("IdleState")
	health.connect("health_changed", Callable(self, "update_health_bar"))
	health.health_depleted.connect(_on_death)
	health.hit.connect(_on_hit)
	update_health_bar(health.current_health)
	

func update_health_bar(new_health: int) -> void:
	witch_health_bar.value = new_health
	

func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(new_state_name)
	if current_state: 
		current_state.enter_state(self)

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1

	move_and_slide()

	# Flip the sprite based on direction
	if direction.x != 0:
		$AnimatedSprite2D.flip_h = direction.x < 0

	if knockback_timer > 0:
		knockback_timer -= delta
		move_and_slide()
		return
		# regular movement code

	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if current_state:
		current_state.handle_input(delta)
	move_and_slide()

func play_animation(animation_name):
	witch_sprite.play(animation_name)

func play_sec_animation(animation_name):
	charge.play(animation_name)

func _on_death():
	change_state("DeathState")

func _on_hit():
	if current_state:
		
		change_state("HurtState")
	
func _on_died():
	print("Witch died")
	queue_free()  # Or trigger death animation and then queue_free
	
func take_damage(amount: int):
	health.take_damage(amount)

func apply_knockback(force: Vector2):
	velocity += force
	knockback_timer = 0.2  # Knockback lasts 0.2 seconds


func _on_camera_zoom_zone_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		body.zoom_to(Vector2(4, 3.25), 1.0)

func zoom_to(target_zoom: Vector2, duration: float):
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "zoom", target_zoom, duration)
	



func _on_camera_zoom_zone_body_exited(body: Node2D) -> void:
	if body.name == "Witch":
		body.zoom_to(Vector2(2, 2), 1.0)
