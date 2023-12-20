extends RigidBody2D

var worth = 1000
var hp = 20

func _on_body_entered(body):
	if body.is_in_group("player"):
		$AudioStreamPlayer2D.play()
		$Label.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$Polygon2D.hide()
		body.add_money(1000)


func hurt(ded):
	hp -= (1 + ded)
	if hp <= 0:
		queue_free()


func _on_timer_timeout():
	queue_free()


func _on_audio_stream_player_2d_finished():
	queue_free()
