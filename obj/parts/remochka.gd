extends RigidBody2D



func _on_body_entered(body):
	if body.is_in_group("player"):
		body.hp += 5
		queue_free()

func hurt(_ded):
	pass
