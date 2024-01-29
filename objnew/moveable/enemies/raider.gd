extends Ai_Ship



func genrnforce():
	#mass = 80
	force = Vector2(0,rng.randi_range(-1000,-1200))

func die_more_personal():
	$hand/Timer.stop()
	$hand.dead = true
	$hand.hide()
