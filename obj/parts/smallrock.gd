extends RigidBody2D
var rng = RandomNumberGenerator.new()
var hp = 3;
var frame = 0;
var dead = false;
@export var worth = 100
@export var useparticles = false

signal died

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = frame
	rng.randomize()
	rotate(rng.randf_range(0.0,PI*2))
	apply_force(Vector2(0,rng.randi_range(100000,300000)).rotated(rng.randf_range(0.0,PI*2)))
	apply_torque(rng.randi_range(3000,6000))
func sell():
	queue_free()

func hurt(ded):
	if dead: return
	hp -= 1;
	hp -= ded;
	if hp <= 0:
		dead = true
		emit_signal("died")
		if useparticles:
			$Sprite2D.hide()
			$CollisionShape2D.queue_free()
			$GPUParticles2D.restart()
		else:
			_on_gpu_particles_2d_finished()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_gpu_particles_2d_finished():
	queue_free()
