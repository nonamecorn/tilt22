extends RigidBody2D
var rng = RandomNumberGenerator.new()
var hp = 50;
var bullet_obj = preload("res://obj/other/explosion.tscn")
var worth = 3000
var collshape = preload("res://obj/other/magnetarea_2d.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	apply_force(Vector2(0,rng.randi_range(700000,1200000)).rotated(rng.randf_range(0.0,PI*2)))

func sell():
	$Area2D.set_deferred("gravity", 0)
	queue_free()

func hurt(ded):
	$AnimationPlayer.play("tryaska")
	if ded >= 4:
		die()
		return
	hp -= 1;
	hp -= ded;
	if hp <= 0:
		die()
		return
func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

func die():
	$Area2D.set_deferred("gravity",0)
	for childmark in $children.get_children():
		var bullet_inst = bullet_obj.instantiate()
		bullet_inst.global_position = childmark.global_position
		call_deferred("add", bullet_inst)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func  _physics_process(_delta):
	if Input.is_action_just_pressed("ui_z"):
		$Area2D.set_deferred("gravity",0)
