extends RigidBody2D

var worth = 100

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.add_money(100)
		queue_free()

func hurt(_ded):
	pass
