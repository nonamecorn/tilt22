extends CharacterBody2D

var speed = 250
var move_vec : Vector2
var mod_vec : Vector2

func init():
	move_vec = Vector2.UP
	move_vec = move_vec.rotated(global_rotation)

func _physics_process(delta):
	var coll = move_and_collide(move_vec * speed * delta)
	if coll:
		destroy_bullet()
		if coll.get_collider().has_method("hurt"):
			deal_damage(coll.get_collider())
		else:
			destroy_bullet()

func deal_damage(body):
	body.hurt()
	destroy_bullet()

func destroy_bullet():
	$AnimatedSprite2D.play()
	


func _on_animated_sprite_2d_animation_finished():
	queue_free()
