extends Area2D

@export var recharge_time: float = 2.0

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.crystal = self
func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		body.crystal = null


func recharge(player: Player) -> void:
	if player.can_jump == false:
		player.can_jump = true
		if player.velocity.y > 0:
			player.velocity.y = 0
		$Sprite.play("recharge")
		self.monitoring = false
		await get_tree().create_timer(recharge_time).timeout
		$Sprite.play("regen")
		self.monitoring = true
