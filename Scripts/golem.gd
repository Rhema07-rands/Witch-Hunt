extends CharacterBody2D
@onready var health: HealthComponentenmy = $HealthComponent
@onready var orc_health_bar: ProgressBar = $"OrcHealthBar UI/OrcHealthBar"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var chase_area: Area2D = $"Detection Area"
@onready var attack_area: Area2D = $"Attack Area"
@onready var orc_state_machine = $"Orc State Machine"
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D = null
var witch_defeated := false
var is_dead: bool= false
@export var mob: PackedScene
@onready var orc_health_bar_ui: Node2D = $"OrcHealthBar UI"
@onready var golem_body: CollisionShape2D = $"Golem Body"

func _ready():
	health.health_depleted.connect(_on_death)
	health.connect("health_changed", Callable(self, "update_health_bar"))
	chase_area.body_entered.connect(_on_detection_area_body_entered)
	chase_area.body_exited.connect(_on_detection_area_body_exited)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	orc_state_machine.change_state("GolemIdle")
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
		orc_state_machine.change_state("GolemChase")
func _on_player_tree_exited():
	print("witch has Actually Died!")
	if not witch_defeated:
		witch_defeated = true
		
		orc_state_machine.change_state("GolemTaunt")
func take_damage(amount: int):
	if health:
		health.take_damage(amount)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		player = null
	orc_state_machine.change_state("GolemAttack")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and orc_state_machine.current_state != $"Orc State Machine/GolemAttack":
		player = body
		orc_state_machine.change_state("GolemAttack")
	

func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and player:
		orc_state_machine.change_state("GolemChase")

func _on_death():
	orc_state_machine.change_state("GolemDeath")


func _on_witch_tree_exited() -> void:
	print("witch has Actually Died!")
	if not witch_defeated:
		witch_defeated = true
		
		orc_state_machine.change_state("GolemTaunt")

func dead():
	var death_position = global_position  # Save location before freeing
	#FinalBossBody.disabled = true
	chase_area.monitoring = false
	attack_area.monitoring = false
	golem_body.disabled = true
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
