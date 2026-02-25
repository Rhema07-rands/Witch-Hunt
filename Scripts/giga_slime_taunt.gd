extends GigaSlimeState
@onready var enemy = get_parent().get_parent()

func enter():
	
	enemy.animated_sprite.play("taunt")
	enemy.velocity = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	enemy.velocity = Vector2.ZERO
