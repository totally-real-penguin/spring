extends CanvasLayer

@export var player: Player

func _enter_tree() -> void:
	var root = get_tree().current_scene
	

func _physics_process(_delta: float) -> void:
	if player != null:
		if player.can_jump or player.can_coyote_jump:
			%CanJump.texture.region = Rect2(0,0,16,16)
		else:
			%CanJump.texture.region = Rect2(0,16,16,16)
