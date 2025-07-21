extends Button

@export var file_name: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file(file_name)
