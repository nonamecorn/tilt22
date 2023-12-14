extends Area2D


# Called when the node enters the scene tree for the first time.
var bullet_objs = [
	"res://obj/parts/smallrock.tscn",
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
	"res://obj/ai/enemy.tscn",
	"res://obj/ai/enemy.tscn",
	"res://obj/ai/enemy2.tscn",
	"res://obj/ai/enemy2.tscn",
	"res://obj/ai/cruiser.tscn"
]

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
func _on_body_entered(body):
	if body.is_in_group("killable"):
		body.queue_free()


func _on_timer_timeout():
	for child in $children.get_children():
		if rng.randi_range(0,1) == 0:
			continue
		bullet_objs.shuffle()
		var bullet_obj = load(bullet_objs[0])
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = child.global_position
		bullet_inst.global_rotation = child.global_rotation
		call_deferred("add", bullet_inst)

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)
