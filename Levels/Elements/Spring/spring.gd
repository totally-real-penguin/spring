extends Area2D

@export var spring_strength: float = 360

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.velocity.y > 0:
			body.velocity.y = -spring_strength
			$AnimationPlayer.play("Spring")
			body.can_jump = true
