extends CharacterBody2D
@onready var health: HealthComponentBoss1 = $HealthComponent
@onready var final_boss_2_health_bar: ProgressBar = $FinalBoss2HealthBar/FinalBoss2HealthBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_1_detection_area: Area2D = $"Attack_1 Detection Area"
@onready var attack_2_detection_area: Area2D = $"Attack_2 Detection Area"
@onready var final_boss_2_state_machine: Node = $"Final Boss State Machine"
signal boss_dead
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D = null
var witch_defeated := false
var is_dead: bool= false

func _ready():
	health.health_depleted.connect(_on_death)
	health.connect("health_changed", Callable(self, "update_health_bar"))
	attack_1_detection_area.body_entered.connect(_on_detection_area_body_entered)
	attack_1_detection_area.body_exited.connect(_on_detection_area_body_exited)
	attack_2_detection_area.body_entered.connect(_on_attack_area_body_entered)
	attack_2_detection_area.body_exited.connect(_on_attack_area_body_exited)
	final_boss_2_state_machine.change_state("FinalBossIdle")
	update_health_bar(health.current_health)

func update_health_bar(new_health):
	final_boss_2_health_bar.value = new_health
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity = Vector2i.ZERO
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		player = body
		final_boss_2_state_machine.change_state("FinalBossAttack_1")

func take_damage(amount: int):
	if health:
		health.take_damage(amount)

func _on_detection_area_body_exited(body: Node2D) -> void:
	
	if body.name == "Witch":
		player = null
		final_boss_2_state_machine.change_state("FinalBossAttack_2")
		

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Witch":
		player = body
		final_boss_2_state_machine.change_state("FinalBossAttack_2")


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.name == "Witch":
		final_boss_2_state_machine.change_state("FinalBossAttack_1")

func die():
	emit_signal("boss_dead")
	queue_free()

func _on_death():
	final_boss_2_state_machine.change_state("FinalBossDeath")


func _on_witch_tree_exited() -> void:
	print("witch has Actually Died!")
	if not witch_defeated:
		witch_defeated = true
		final_boss_2_state_machine.change_state("FinalBossIdle")
