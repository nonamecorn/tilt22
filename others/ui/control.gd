extends Control
@onready var player = get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
	if Input.is_action_just_pressed("ui_esc"):
		hide()

func _on_esc_pressed():
	hide()


func _on_talk_pressed():
	$RichTextLabel.text = "thanks, but im fine"


func _on_repair_pressed():
	if player.money >= 500:
		player.repair()
		player.deduct_money(500)
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"


func _on_handyman_buy_pressed():
	if player.money >= 0:
		player.repair()
		player.deduct_money(0)
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"
		return
	var handy_inst = load("res://obj/player/handyman.tscn").instantiate()
	var spawn = get_tree().get_nodes_in_group("spawn")[0]
	handy_inst.global_position = spawn.global_position
	handy_inst.global_rotation = spawn.global_rotation
	call_deferred("add", handy_inst)
	get_tree().get_nodes_in_group("player")[0].queue_free()

func _on_cruise_driller_pressed():
	pass # Replace with function body.

func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)

var thrust_price = 500
func _on_better_thrusters_pressed():
	if player.money >= 500:
		player.force -= 1000
		player.deduct_money(500)
		thrust_price += 500
		$uppgrades/upgrades/VBoxContainer/PanelContainer/Label.text = str(thrust_price) + " credits"
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"

var armor_price = 500
func _on_better_armor_pressed():
	if player.money >= 500:
		player.maxhp += 10
		player.repair()
		player.deduct_money(500)
		armor_price += 500
		$uppgrades/upgrades/VBoxContainer/PanelContainer2/Label.text = str(armor_price) + " credits"
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"
