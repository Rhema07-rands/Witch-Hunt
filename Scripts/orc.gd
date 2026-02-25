extends CharacterBody2D
@onready var health: HealthComponentenmy = $HealthComponent
@onready var orc_health_bar: ProgressBar = $"OrcHealthBar UI/OrcHealthBar"
@onready var detection_area: Area2D = $"Detection Area"
@onready var detection_area_collision: CollisionShape2D = $"Detection Area/Detection Area Collision"
@onready var orc_body: CollisionShape2D = $"Orc Body"
@onready var orc_health_bar_ui: Node2D = $"OrcHealthBar UI"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var chase_area: Area2D = $"Detection Area"
@onready var attack_area: Area2D = $"Attack Area"
@onready var orc_state_machine = $"Orc State Machine"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D = null
var witch_defeated := false
var is_dead: bool= false
@export var mob: PackedScene
func _ready():
	health.health_depleted.connect(_on_death)
	health.hit.connect(_on_hit)
	health.connect("health_changed", Callable(self, "update_health_bar"))
	chase_area.body_entered.connect(_on_detection_area_body_entered)
	chase_area.body_exited.connect(_on_detection_area_body_exited)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	orc_state_machine.change_state("OrcIdle")
	update_health_bar(health.current_health)

func update_health_bar(new_health):
	orc_health_bar.value = new_health
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		player = body
		orc_state_machine.change_state("OrcChase")
func _on_player_tree_exited():
	print("witch has Actually Died!")
	if not witch_defeated:
		witch_defeated = true
		
		orc_state_machine.change_state("OrcTaunt")
func take_damage(amount: int):
	if health:
		health.take_damage(amount)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		player = null
	orc_state_machine.change_state("OrcIdle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and orc_state_machine.current_state != $"Orc State Machine/OrcAttack":
		player = body
		orc_state_machine.change_state("OrcAttack")
	

func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and player:
		orc_state_machine.change_state("OrcChase")

func _on_death():
	
	orc_state_machine.change_state("OrcDeath")
	
func _on_hit():
	if orc_state_machine.current_state:
		
		orc_state_machine.change_state("OrcHurt")

func dead():
	var death_position = global_position  # Save location before freeing
	#FinalBossBody.disabled = true
	detection_area.monitoring = false
	attack_area.monitoring = false
	orc_body.disabled = true
	detection_area_collision.disabled = true
	animated_sprite.hide()
	orc_health_bar_ui.hide()
	await get_tree().create_timer(5.0).timeout
	
	spawn_phase_2(death_position)
	queue_free()
#	wall.queue_free()

func spawn_phase_2(position: Vector2):
	if mob:
		var phase_2 = mob.instantiate()
		get_tree().current_scene.add_child(phase_2)
		phase_2.global_position = position

func _on_witch_tree_exited() -> void:
	print("witch has Actually Died!")
	if not witch_defeated:
		witch_defeated = true
		
		orc_state_machine.change_state("OrcTaunt")
