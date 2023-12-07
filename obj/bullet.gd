extends CharacterBody2D

var speed = 250
var move_vec : Vector2
var mod_vec : Vector2

func init(vel,cof):
	move_vec = Vector2.RIGHT
	move_vec = move_vec.rotated(global_rotation) + vel.normalized() * cof

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
	queue_free()
