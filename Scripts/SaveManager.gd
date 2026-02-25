extends Node
var level_select_intro_played := false
var save_path := "user://save_data.json"
var completed_levels: Array = []
var save_data: Dictionary = { "player_positon": null}

func _ready():
	load_progress()

func load_progress():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_as_text()
		var json = JSON.parse_string(data)
		file.close()
		if typeof(json) == TYPE_DICTIONARY:
			completed_levels = json.get("completed_levels", [])
			level_select_intro_played = json.get("level_select_intro_played", false)
	else:
		completed_levels = []
		level_select_intro_played = false

func save_data_to_file():
	var file = FileAccess.open("user://save_data.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

func save_progress():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data = {
		"completed_levels": completed_levels,
		"level_select_intro_played": level_select_intro_played
	}
	file.store_string(JSON.stringify(data))
	file.close()

func mark_level_complete(level_name: String):
	if not completed_levels.has(level_name):
		completed_levels.append(level_name)
		save_progress()

func is_level_complete(level_name: String) -> bool:
	return completed_levels.has(level_name)

func delete_save_data():
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
		completed_levels = []
		print("Save File Deleted.")

func has_save_data() -> bool:
	var result = FileAccess.file_exists(save_path)
	return result == true

func save_player_position(position: Vector2):
	save_data["player_position"] = {"x": position.x, "y": position.y}
	save_data_to_file()

func load_player_position() -> Vector2:
	if "player_position" in save_data and save_data["player_position"] != null:
		var pos_dict = save_data["player_position"]
		return Vector2(pos_dict["x"], pos_dict["y"])
	return Vector2.ZERO

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_progress()

func _exit_tree() -> void:
	save_progress()
