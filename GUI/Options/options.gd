extends Panel

@export var music_vol: Label
@export var music_slider: HSlider

@export var audio_vol: Label
@export var audio_slider: HSlider

func _process(_delta: float) -> void:
	Settings.sound_volume = audio_slider.value
	audio_vol.text = str(int(Settings.sound_volume)) + "%"
	
	Settings.music_volume = music_slider.value
	music_vol.text = str(int(Settings.music_volume)) + "%"

func _on_save_settings_pressed() -> void:
	self.visible = false


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
	elif index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
