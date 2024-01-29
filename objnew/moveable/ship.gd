extends BasicObject

class_name Ship

var bullet_obj = preload("res://objnew/moveable/scrap.tscn")
@export var scrap_texture: Texture
@export var frame_array = [0,0]
var force: Vector2 = Vector2.ZERO;
@export var turn_speed: float = 0.0;


func die():
	dead = true
	linear_damp = 0
	$AnimatedSprite2D.play()
	$death_audio.play()
	$Playership.hide()
	for childmark in $scrap_points.get_children():
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.texture = scrap_texture
		bullet_inst.frames = frame_array
		bullet_inst.global_position = childmark.global_position
		bullet_inst.global_rotation = childmark.global_rotation
		bullet_inst.frame = childmark.get_index()
		call_deferred("add", bullet_inst)
	die_more_personal()
func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)
func die_more_personal():
	pass

func _on_animated_sprite_2d_animation_finished():
	if $death_audio.playing:
		return
	queue_free()


func _on_death_audio_finished():
	queue_free()
