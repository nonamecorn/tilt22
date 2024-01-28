extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if event.pressed:
			get_tree().quit()
