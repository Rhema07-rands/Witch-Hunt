extends CharacterBody2D
const  SPEED = 90.0
const JUMP_VELOCITY = -295.0
var current_state
var last_facing_direction := 1
@onready var witch_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: HealthComponentFinalStage = $HealthComponent
@onready var witch_health_bar: ProgressBar = $WitchHealthBar/WitchHealthBar
#var velocity = Vector2.ZERO
var coyote_time := 0.5
var coyote_timer := 0.0
var knockback_timer = 0.0
@onready var camera: Camera2D = $Camera2D
@export var heal_amount := 150
@export var max_heals := 5
@onready var heal_label: Label = $WitchHealthBar/Label
var heal_uses_left := max_heals
@onready var witch_slime_mode: CollisionShape2D = $"Witch Slime Mode"
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var  witch_slime_mode_hitbox: CollisionShape2D = $"Witch Slime Mode Hitbox/CollisionShape2D"
@onready var  witch_slime_mode_hitbox_2: CollisionShape2D = $"Witch Slime Mode Hitbox/CollisionShape2D2"
var can_use_t := true
var t_cooldown := 100.0
var t_timer := 0.0
@onready var cooldown_label: Label = $WitchHealthBar/Label2
@onready var charge: AnimatedSprite2D = $Charge

func _ready():
	change_state("IdleState")
	health.connect("health_changed", Callable(self, "update_health_bar"))
	health.health_depleted.connect(_on_death)
	health.hit.connect(_on_hit)
	update_health_bar(health.current_health)
	animated_sprite_2d_2.hide()
	witch_slime_mode_hitbox.disabled=true
	witch_slime_mode_hitbox_2.disabled=true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("heal") and heal_uses_left > 0:
		_heal()
	heal_label.text = "Heals left: %d" % heal_uses_left
	if Input.is_action_just_pressed("transform") and can_use_t:
		can_use_t = false
		t_timer = t_cooldown
		_perform_t_action()

	# Handle countdown
	handle_countdown(_delta)

	# Update the label every frame
	_update_label()


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
		witch_sprite.flip_h = direction.x < 0
		animated_sprite_2d_2.flip_h = direction.x < 0
		
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


func _heal():
	if health.current_health < health.max_health:
		var new_health = min(health.current_health + heal_amount, health.max_health)
		health.current_health = new_health
		update_health_bar(health.current_health)
		heal_uses_left -= 1
		print("Healed! Heals left:", heal_uses_left)
	else:
		print("Health is already full.")

func _on_camera_zoom_zone_body_exited(body: Node2D) -> void:
	if body.name == "Witch":
		body.zoom_to(Vector2(1, 1), 1.0)

func handle_countdown(_delta):
	if not can_use_t:
		t_timer -= _delta
		if t_timer <= 0:
			t_timer = 0
			can_use_t = true

func _update_label():
	if can_use_t:
		cooldown_label.text = "T Ready!"
	else:
		cooldown_label.text = "Cooldown: %.0f seconds" % t_timer

func _perform_t_action():
	print("T key pressed. Action performed.")
	# Add your transformation or logic here
	change_state("WitchSlimeMode")
