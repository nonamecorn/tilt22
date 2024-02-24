extends Control


func _input(event):
	if event.is_action_pressed("ui_r"):
		if !visible and get_tree().paused:
			return
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_button_pressed():
	get_tree().paused = false
	Global.restore()
	get_tree().reload_current_scene()


func _on_button_2_pressed():
	get_tree().paused = false
	hide()
