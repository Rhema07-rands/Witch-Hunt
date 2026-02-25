extends State
@onready var attack_collision_box: Area2D = $"../Attack collision Box"

@onready var damage_collision_hurtbox_2: CollisionShape2D = $"../Attack collision Box/Damage Collision Hurtbox2"
@onready var damage_collision_hurtbox: CollisionShape2D = $"../Attack collision Box/Damage Collision Hurtbox"

@onready var witch_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"


var attack_duration: float = 2.0
var attack_timer: float = 0.0

func enter_state(player_node):
	super(player_node)
	attack_collision_box.body_entered.connect(_on_attack_collision_body_entered)
	attack_collision_box.monitoring = true
	player.play_animation("attack")
	player.play_sec_animation("null")
	attack_timer = attack_duration
	if witch_sprite.flip_h:
		damage_collision_hurtbox_2.disabled = false
		damage_collision_hurtbox.disabled = true
	else:
		damage_collision_hurtbox.disabled = false
		damage_collision_hurtbox_2.disabled = true
		
	
	
	
func exit_state():
	attack_collision_box.monitoring = false
	attack_collision_box.body_entered.disconnect(_on_attack_collision_body_entered)


	


func handle_input(_delta):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.JUMP_VELOCITY
	elif Input.is_action_just_pressed("dash"):
		player.change_state("DashState")
	update_state(_delta)

func update_state(delta):
	attack_timer -= delta

	if attack_timer <= 0:
		if Input.is_action_just_pressed("charge"):
			player.change_state("AOEAttackState")
		else:
			player.change_state("IdleState")


func _on_attack_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(10)
		print("enemy hit -10")
