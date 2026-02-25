extends Node

var current_state: GigaSlimeState

#func _ready():
	#change_state("OrcIdle")  # Start in Idle

func change_state(state_name: String):
	if current_state:
		current_state.exit()
	var new_state = get_node(state_name)
	if new_state:
		current_state = new_state
		current_state.enter()

func _physics_process(delta):
	if current_state:
		current_state._physics_process(delta)
