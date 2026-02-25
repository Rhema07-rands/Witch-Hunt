extends Area2D

@export var target_zoom := Vector2(2, 2)  # Zoom in (smaller value = closer)
@export var zoom_duration := 1.0  # Seconds

var zoom_start: Vector2
var zoom_timer := 0.0
var zooming := false

@onready var player_camera: Camera2D = $"../Witch/Camera2D"
func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Witch":  # Replace with your player node name
		if player_camera:
			zoom_start = player_camera.zoom
			zoom_timer = 0.0
			zooming = true

func _process(delta):
	if zooming and player_camera:
		zoom_timer += delta
		var t = clamp(zoom_timer / zoom_duration, 0, 1)
		player_camera.zoom = zoom_start.lerp(target_zoom, t)
		if t >= 1.0:
			zooming = false
