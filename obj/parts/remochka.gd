extends RigidBody2D

var worth = 500
var hp = 20

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.hp <= body.maxhp - 5:
			$AudioStreamPlayer2D.play()
			$Label.hide()
			$CollisionShape2D.set_deferred("disabled", true)
			body.hp += 5
			body.updatehpbar()

func hurt(ded):
	hp -= (1 + ded)
	if hp <= 0:
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_audio_stream_player_2d_finished():
	queue_free()
