extends Node2D


# Called when the node enters the scene tree for the first time.
var bullet_objs = [
	"res://obj/parts/medium_rock.tscn",
	"res://obj/parts/big_rock.tscn",
	"res://obj/parts/medium_rock.tscn",
	"res://obj/parts/big_rock.tscn",
	"res://obj/parts/medium_rock.tscn",
	"res://obj/parts/big_rock.tscn",
	"res://obj/parts/medium_rock.tscn",
	"res://obj/parts/big_rock.tscn",
	"res://obj/parts/explosive_rock.tscn",
	"res://obj/parts/explosive_rock.tscn",
	"res://obj/ai/scout.tscn",
	"res://obj/ai/enemy.tscn",
	"res://obj/ai/enemy.tscn",
	"res://obj/ai/enemy2.tscn",
	"res://obj/ai/enemy2.tscn",
	"res://obj/ai/cruiser.tscn",
]
@export var on = true
var rng = RandomNumberGenerator.new()
var count = 0;
@export var maximum_meat_capacity = 100;
@onready var station = "res://obj/other/mini_static_station.tscn"

func _ready():
	rng.randomize()
	
#func _on_body_entered(body):
	#if body.is_in_group("killable"):
		#body.queue_free()

func on_death():
	count -= 1;


func _on_timer_timeout():
	if !on or count >= maximum_meat_capacity: return
	for child in $children.get_children():
		if count >= maximum_meat_capacity or rng.randi_range(0,1) == 0 or Geometry2D.is_point_in_circle(child.global_position, Vector2(430.0,-670.0), 1000.0):
			continue
		count += 1;
		bullet_objs.shuffle()
		var bullet_obj = load(bullet_objs[0])
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.died.connect(on_death)
		bullet_inst.global_position = child.global_position
		bullet_inst.global_rotation = child.global_rotation
		call_deferred("add", bullet_inst)

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

func _on_area_2d_body_entered(body):
	body.global_position.y -= 4900


func _on_area_2d_3_body_entered(body):
	body.global_position.y += 4900


func _on_area_2d_2_body_entered(body):
	body.global_position.x += 6900


func _on_area_2d_4_body_entered(body):
	body.global_position.x -= 6900
