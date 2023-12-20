extends RigidBody2D

var spark = preload("res://obj/projs/spark.tscn")
var rng = RandomNumberGenerator.new()
var iteration = 0
var max_iterations = 3
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
func init(vec: Vector2, rot,it):
	apply_impulse(Vector2(0,-1000).rotated(global_rotation + rot) + vec)
	iteration = it




func _on_body_entered(body):
	if body.has_method("hurt"):
		body.hurt(0)
		var bullet_inst = spark.instantiate()
		bullet_inst.global_position = global_position
		bullet_inst.global_rotation = global_rotation
		get_tree().current_scene.add_child.call_deferred(bullet_inst)
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()


func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_timer_timeout():
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play()


func _on_area_2d_body_entered(body):
	if dead: return
	dead = true
	if body.has_method("hurt"):
		body.hurt(0)
		var spark_inst = spark.instantiate()
		spark_inst.global_position = global_position
		get_tree().current_scene.add_child.call_deferred(spark_inst)
		if iteration == max_iterations:
			_on_animated_sprite_2d_animation_finished()
			return
		var bullet_obj = load("res://obj/projs/newbullet.tscn")
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = global_position
		bullet_inst.global_rotation = global_rotation
		bullet_inst.init(Vector2.ZERO,0.12,iteration + 1)
		get_tree().current_scene.add_child.call_deferred(bullet_inst)
		var bullet_inst2 = bullet_obj.instantiate()
		bullet_inst2.global_position = global_position
		bullet_inst2.global_rotation = global_rotation
		bullet_inst2.init(Vector2.ZERO,-0.12,iteration + 1)
		get_tree().current_scene.add_child.call_deferred(bullet_inst2)
		_on_animated_sprite_2d_animation_finished()
		



