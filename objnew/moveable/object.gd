extends RigidBody2D

class_name BasicObject

var rng = RandomNumberGenerator.new()
@export var hp: int
var dead = false

func _ready():
	rng.randomize()

func hurt(ammount):
	if dead: return
	$AnimationPlayer.play("tryaska")
	hp -= ammount
	if hp <= 0:
		die()

func die():
	pass
