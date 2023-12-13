extends RigidBody2D

var path
# Called when the node enters the scene tree for the first time.
func _ready():
	init()
func init():
	$chain6/PinJoint2D2.node_a = path

