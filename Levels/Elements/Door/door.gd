extends StaticBody2D


func _on_key_checker_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.keys > 0:
			body.keys -= 1
			body.update_keys()
			self.call_deferred("queue_free")
