extends CharacterBody2D
@onready var health: HealthComponentBoss = $HealthComponent
@onready var giga_slime_health_bar: ProgressBar = $GigaSlimeHealthBar/GigaSlimeHealthBar

@onready var wall: StaticBody2D = $"../Wall"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var chase_area: Area2D = $"Detection Area"
@onready var attack_area: Area2D = $"Attack Area"
@onready var giga_slime_state_machine: Node = $"Giga Slime State Machine"

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
	giga_slime_state_machine.change_state("GigaSlimeIdle")
	update_health_bar(health.current_health)

func update_health_bar(new_health):
	giga_slime_health_bar.value = new_health
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		player = body
		giga_slime_state_machine.change_state("GigaSlimeChase")

func take_damage(amount: int):
	if health:
		health.take_damage(amount)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		player = null
		
	giga_slime_state_machine.change_state("GigaSlimeIdle")


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and giga_slime_state_machine.current_state != $"Giga Slime State Machine/GigaSlimeAttack":
		player = body
		giga_slime_state_machine.change_state("GigaSlimeAttack")
	

func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and player:
	
		giga_slime_state_machine.change_state("GigaSlimeChase")
		

func _on_death():
	attack_area.monitoring = false
	chase_area.monitoring = false
	giga_slime_state_machine.change_state("GigaSlimeDeath")
	
func _on_hit():
	if giga_slime_state_machine.current_state:
		
		giga_slime_state_machine.change_state("GigaSlimeHurt")
