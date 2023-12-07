extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func init(vec: Vector2):
	apply_impulse(Vector2(0,-1000).rotated(global_rotation) + vec)





func _on_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()


func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_timer_timeout():
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()
