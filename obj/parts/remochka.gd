extends RigidBody2D

var worth = 500
var hp = 20

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.hp <= body.maxhp - 5:
			$AudioStreamPlayer2D.play()
			$Sprite2D.hide()
			body.hp += 5
			body.updatehpbar()
			$CollisionShape2D.queue_free()
		else:
			$AudioStreamPlayer2D.play()
			$Sprite2D.hide()
			body.hp = body.maxhp
			body.updatehpbar()
			$CollisionShape2D.queue_free()
func sell():
	queue_free()

func hurt(ded):
	hp -= (1 + ded)
	if hp <= 0:
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_audio_stream_player_2d_finished():
	queue_free()
