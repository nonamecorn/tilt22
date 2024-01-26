extends Node2D

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_degrees = randi_range(0,360)
	for child in get_children():
		if Geometry2D.is_point_in_circle(child.global_position, Vector2(430.0,-670.0), 1000.0):
			continue
		var bullet_obj = load("res://obj/other/mini_static_station.tscn")
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = child.global_position
		call_deferred("add", bullet_inst)

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)
