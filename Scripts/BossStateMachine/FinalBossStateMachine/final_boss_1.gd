extends CharacterBody2D
@onready var health: HealthComponentBoss = $HealthComponent
@onready var final_boss_1_health_bar: ProgressBar = $FinalBoss1HealthBar/FinalBoss1HealthBar
@onready var FinalBossBody: CollisionShape2D = $CollisionShape2D
@onready var dash_detection_area: Area2D = $"Dash Detection Area"
#@onready var main = get_parent()
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $"Attack Area"
@onready var final_boss_1_state_machine: Node = $"Final Boss State Machine"
@onready var collision_shape: CollisionShape2D = $"Dash Detection Area/CollisionShape2D"
@onready var c_iircle: Label = $"../CanvasLayer Fake/CIircle"
@onready var slime_spirit: Label = $"../CanvasLayer Fake/Slime Spirit"
@onready var slime_spirit_2: AnimatedSprite2D = $"../CanvasLayer Fake/Slime Spirit2"
@onready var main_level = get_parent()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player: Node2D = null
var witch_defeated := false
var return_to_patrol_timer: Timer = null
@onready var state_machine = $"Final Boss State Machine"
var patrol_state_scene = preload("res://Scripts/BossStateMachine/FinalBossStateMachine/final_boss_1_patrol.gd")  # Replace with actual path
@export var final_boss_2_scene: PackedScene = preload("res://Scenes/final_boss_2.tscn")
var is_dead: bool= false

func _ready():
	health.health_depleted.connect(_on_death)
	health.hit.connect(_on_hit)
	health.connect("health_changed", Callable(self, "update_health_bar"))
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)
	final_boss_1_state_machine.change_state("FinalBossPatrol")
	update_health_bar(health.current_health)

func update_health_bar(new_health):
	final_boss_1_health_bar.value = new_health
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity = Vector2i.ZERO
	

func take_damage(amount: int):
	if health:
		health.take_damage(amount)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and final_boss_1_state_machine.current_state!= $"Final Boss State Machine/FinalBossAttack":
		player = body
		# Enter attack state
		collision_shape.call_deferred("set_disabled", true)
		dash_detection_area.monitoring = false
		final_boss_1_state_machine.change_state("FinalBossAttack")


func _on_attack_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch" and player:
		await get_tree().create_timer(2.0).timeout
		collision_shape.call_deferred("set_disabled", false)
		dash_detection_area.monitoring = true
		final_boss_1_state_machine.change_state("FinalBossChase")

func _on_death():
	
	final_boss_1_state_machine.change_state("FinalBossDeath")

func _died():
	c_iircle.show()
	slime_spirit.show()
	slime_spirit_2.show()
	var death_position = global_position  # Save location before freeing
	FinalBossBody.disabled = true
	dash_detection_area.monitoring = false
	attack_area.monitoring = false
	animated_sprite.hide()
	await get_tree().create_timer(10.0).timeout
	
	spawn_phase_2(death_position)
	queue_free()

func spawn_phase_2(position: Vector2):
	if final_boss_2_scene:
		var phase_2 = final_boss_2_scene.instantiate()
		phase_2.connect("boss_dead", Callable(main_level, "_on_boss_dead"))
		get_tree().current_scene.add_child(phase_2)
		phase_2.global_position = position

	
func _on_hit():
	if final_boss_1_state_machine.current_state:
		
		final_boss_1_state_machine.change_state("FinalBossHurt")


func _on_dash_detection_area_body_entered(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		player = body

		# Delete patrol to prevent interference
		if final_boss_1_state_machine.has_node("FinalBossPatrol"):
			final_boss_1_state_machine.get_node("FinalBossPatrol").queue_free()
		var random_choice = randi() % 2  # 0 or 1
		if random_choice == 0:
			final_boss_1_state_machine.change_state("FinalBossChase")
		else:
			final_boss_1_state_machine.change_state("FinalBossDashAttack")


func _on_dash_detection_area_body_exited(body: Node2D) -> void:
	if is_dead: return
	if body.name == "Witch":
		final_boss_1_state_machine.change_state("FinalBossAttack")


func _on_witch_tree_exited() -> void:
	print("witch has Actually Died!")
	var patrol_instance = patrol_state_scene.new()
	patrol_instance.name = "FinalBossChase"
	state_machine.add_child(patrol_instance)
	if not witch_defeated:
		witch_defeated = true
		final_boss_1_state_machine.change_state("FinalBossPatrol")
