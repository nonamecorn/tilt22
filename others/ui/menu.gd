extends Control




# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = !visible


func _on_check_box_toggled(toggled_on):
	if toggled_on:
		Ostmanager.pause()
	else:
		Ostmanager.resume()


func _on_button_pressed():
	pass # Replace with function body.
