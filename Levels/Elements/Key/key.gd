extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.keys += 1
		body.update_keys()
		self.call_deferred("queue_free")
