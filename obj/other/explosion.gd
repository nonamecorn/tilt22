extends Area2D

var exp_scale = 1
var damage = 2

func _ready():
	scale = Vector2(exp_scale,exp_scale) 

func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_timer_timeout():
	for body in get_overlapping_bodies():
		body.hurt(damage)
		body.apply_force((body.global_position - global_position) * 2)
