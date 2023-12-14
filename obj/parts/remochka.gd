extends RigidBody2D

var worth = 500

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.hp <= body.maxhp - 5:
			body.hp += 5
			queue_free()

func hurt(_ded):
	pass
