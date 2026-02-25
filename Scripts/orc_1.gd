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
		velocity += get_gravity() * delta
	move_and_slide()

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
	queue_free()

func _on_witch_tree_exited() -> void:
	print("witch has Actually Died!")
	if not witch_defeated:
		witch_defeated = true
		
		orc_state_machine.change_state("OrcTaunt")
