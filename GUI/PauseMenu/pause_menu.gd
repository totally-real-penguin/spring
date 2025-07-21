extends CanvasLayer

var paused = false

func _on_resume_pressed() -> void:
	$Pause.visible = !$Pause.visible
	paused = !paused
	get_tree().set_deferred("paused",paused)
	if $Pause.visible:
		$PauseButton.icon = preload("res://GUI/PauseMenu/resume.png")
	else:
		$PauseButton.icon = preload("res://GUI/PauseMenu/pause.png")

func _on_options_pressed() -> void:
	$Options.visible = true


func _on_exit_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://GUI/MainMenu/main_menu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_pause_button_pressed() -> void:
	$Pause.visible = !$Pause.visible
	if $Pause.visible:
		$PauseButton.icon = preload("res://GUI/PauseMenu/resume.png")
	else:
		$PauseButton.icon = preload("res://GUI/PauseMenu/pause.png")
