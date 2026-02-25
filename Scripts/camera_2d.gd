extends Camera2D

var zoom_start: Vector2
var zoom_end: Vector2
var zoom_duration: float = 1.0
var zoom_timer: float = 0.0
var zooming := false

func start_zoom(new_zoom: Vector2, duration: float):
	zoom_start = zoom
	zoom_end = new_zoom
	zoom_duration = duration
	zoom_timer = 0.0
	zooming = true

func _process(delta):
	if zooming:
		zoom_timer += delta
		var t = clamp(zoom_timer / zoom_duration, 0, 1)
		zoom = zoom_start.lerp(zoom_end, t)
		if t >= 1.0:
			zooming = false
