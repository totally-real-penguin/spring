extends Control

@onready var button_scene = load("res://GUI/LevelSelect/button.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://GUI/MainMenu/main_menu.tscn")

func _ready() -> void:
	for file in DirAccess.get_files_at("res://Levels/LevelScenes/"):
		var button = button_scene.instantiate()
		button.text = file.split(".")[0]
		button.file_name = "res://Levels/LevelScenes/" + file
		%GridContainer.add_child(button)
