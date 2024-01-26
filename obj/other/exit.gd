extends Area2D



func _on_body_entered(_body):
	Ostmanager.play(0)
	call_deferred("next")

func next():
	get_tree().change_scene_to_file("res://others/endscreen.tscn")
