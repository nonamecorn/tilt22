extends RigidBody2D

signal died

var rng = RandomNumberGenerator.new()
var hp = 10;
var bullet_obj = preload("res://obj/parts/medium_rock.tscn")

var worth = 5
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	apply_force(Vector2(0,rng.randi_range(700000,1200000)).rotated(rng.randf_range(0.0,PI*2)))

func sell():
	queue_free()

func hurt(ded):
	if dead: return
	$AnimationPlayer.play("tryaska")
	hp -= 1;
	hp -= ded;
	if hp <= 0:
		emit_signal("died")
		dead = true
		
		for childmark in $children.get_children():
			var bullet_inst = bullet_obj.instantiate()
			bullet_inst.global_position = childmark.global_position
			bullet_inst.global_rotation = childmark.global_rotation
			call_deferred("add", bullet_inst)
			
		queue_free()
func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
