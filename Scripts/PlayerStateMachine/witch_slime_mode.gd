extends State
@onready var witch_sprite: AnimatedSprite2D = $"../AnimatedSprite2D2"
@onready var player1 = get_parent()
var attack_duration: float = 7.5
var attack_timer: float = 0.0
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var running_and_jumping_hitbox_2: CollisionShape2D = $"../Running And Jumping Hitbox2"
@onready var witch_slime_mode: CollisionShape2D = $"../Witch Slime Mode"
@onready var collision_shape_2d: CollisionShape2D = $"../Witch Slime Mode Hitbox/CollisionShape2D"
@onready var collision_shape_2d_2: CollisionShape2D = $"../Witch Slime Mode Hitbox/CollisionShape2D2"
@onready var witch_slime_mode_hitbox: Area2D = $"../Witch Slime Mode Hitbox"
@onready var charge: AnimatedSprite2D = $"../Charge"

func enter_state(player_node):
	super(player_node)
	collision_shape_2d.call_deferred("set_disabled", true)
	collision_shape_2d_2.call_deferred("set_disabled", true)
	running_and_jumping_hitbox_2.disabled = true
	witch_slime_mode.disabled = false
	attack_timer = attack_duration
	animated_sprite_2d.hide()
	charge.hide()
	witch_sprite.show()
	witch_sprite.play("witch_slime_mode")
	await witch_sprite.animation_finished
	witch_sprite.hide()
	animated_sprite_2d.show()
	charge.show()
	running_and_jumping_hitbox_2.disabled = false
	witch_slime_mode.disabled = true

func handle_input(_delta):
	update_state(_delta)

func update_state(delta):
	attack_timer -= delta
		
	if attack_timer <= 0:
		
		player.change_state("IdleState")





func _on_animated_sprite_2d_2_frame_changed() -> void:
	if witch_sprite.animation == "witch_slime_mode":
		var current_frame = witch_sprite.frame
		if current_frame == 37:
			collision_shape_2d_2.call_deferred("set_disabled", false)
			
		else:
			collision_shape_2d_2.call_deferred("set_disabled", true)
			
		if witch_sprite.flip_h:
			collision_shape_2d_2.call_deferred("set_disabled", true)
			
			if current_frame == 37:
				collision_shape_2d.call_deferred("set_disabled", false)
			else:
				collision_shape_2d.call_deferred("set_disabled", true)


func _on_witch_slime_mode_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(200)
		print("enemy hit  200")
		body.velocity.y = -200
