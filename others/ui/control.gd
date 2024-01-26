extends Control
@onready var player = get_parent().get_parent()
@onready var off = $cars/cars/VBoxContainer/PanelContainer3
@onready var hand = $cars/cars/VBoxContainer/PanelContainer
@onready var drill = $cars/cars/VBoxContainer/PanelContainer2

var dils = [
	#"did you know that in 1962 USSR scientists found out heaviest life form... ur mom",
	#"this station is powered by a small black hole thats even heavier than your mom",
	"did you know that warp weapons is really busted but its not cool so nobody uses it",
	"from the moment i understood the weakness of my flesh i... went to the gym",
	"did you know that because of europe, there are more submarines than spaceships in space",
	"did you know that there are more explosive minerals than on Hoxxes IV?",
	"dont venture to abandoned moons without shovel",
	"need money? try selling some scrap by pushing it into the red zone",
	"did you know that by pressing z and x you can create and destroy rat kings while using harpoon",
	"did you know that by pressing 1 2 3 you can control different attachments of your ship"
]

func set_text():
	for carind in Global.bought:
		$cars/cars/VBoxContainer.get_child(carind).get_child(0).text = "switch"
		$cars/cars/VBoxContainer.get_child(carind).get_child(1).text = ""
	$cars/cars/VBoxContainer.get_child(Global.current).get_child(0).text = "current"
	

func _ready():
	set_text()

func _process(_delta):
	if Input.is_action_just_pressed("ui_esc") and visible:
		get_tree().paused = false
		hide()

func _on_esc_pressed():
	get_tree().paused = false
	hide()


func _on_talk_pressed():
	dils.shuffle()
	$RichTextLabel.text = dils[0]


func _on_repair_pressed():
	if Global.money >= 500:
		player.repair()
		player.deduct_money(500)
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"

func _on_offender_buy_pressed():
	if off.get_child(0).text == "switch":
		Global.current = 0
		var off_inst = load("res://obj/player/player.tscn").instantiate()
		var spawn = get_tree().get_nodes_in_group("spawn")[0]
		off_inst.global_position = spawn.global_position
		off_inst.global_rotation = spawn.global_rotation
		call_deferred("add", off_inst)
		_on_esc_pressed()
		get_tree().get_nodes_in_group("player")[0].queue_free()
		return
	elif hand.get_child(0).text == "current":
		return

func _on_handyman_buy_pressed():
	var handy_inst
	var spawn
	
	if hand.get_child(0).text == "switch":
		Global.current = 1
		handy_inst = load("res://obj/player/handyman.tscn").instantiate()
		spawn = get_tree().get_nodes_in_group("spawn")[0]
		handy_inst.global_position = spawn.global_position
		handy_inst.global_rotation = spawn.global_rotation
		call_deferred("add", handy_inst)
		_on_esc_pressed()
		get_tree().get_nodes_in_group("player")[0].queue_free()
		return
	elif hand.get_child(0).text == "current":
		return
	
	if Global.money >= 4000:
		player.repair()
		player.deduct_money(4000)
		$RichTextLabel.text = "done"
		Global.bought.append(1)
		Global.current = 1
		set_text()
		$cars/cars/VBoxContainer/PanelContainer/handymanbuy.text = "current"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"
		return
	handy_inst = load("res://obj/player/handyman.tscn").instantiate()
	spawn = get_tree().get_nodes_in_group("spawn")[0]
	handy_inst.global_position = spawn.global_position
	handy_inst.global_rotation = spawn.global_rotation
	call_deferred("add", handy_inst)
	_on_esc_pressed()
	get_tree().get_nodes_in_group("player")[0].queue_free()

func _on_cruise_driller_pressed():
	var driller_inst
	var spawn
	if drill.get_child(0).text == "switch":
		Global.current = 2
		driller_inst = load("res://obj/player/drilldoser.tscn").instantiate()
		spawn = get_tree().get_nodes_in_group("spawn")[0]
		driller_inst.global_position = spawn.global_position
		driller_inst.global_rotation = spawn.global_rotation
		call_deferred("add", driller_inst)
		_on_esc_pressed()
		get_tree().get_nodes_in_group("player")[0].queue_free()
		return
	elif drill.get_child(0).text == "current":
		return
	
	if Global.money >= 7000:
		player.repair()
		player.deduct_money(7000)
		$RichTextLabel.text = "done"
		Global.bought.append(2)
		Global.current = 2
		set_text()
		$cars/cars/VBoxContainer/PanelContainer/handymanbuy.text = "current"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"
		return
	driller_inst = load("res://obj/player/drilldoser.tscn").instantiate()
	spawn = get_tree().get_nodes_in_group("spawn")[0]
	driller_inst.global_position = spawn.global_position
	driller_inst.global_rotation = spawn.global_rotation
	call_deferred("add", driller_inst)
	_on_esc_pressed()
	get_tree().get_nodes_in_group("player")[0].queue_free()


func add(de_bullet_inst):
	get_tree().current_scene.add_child(de_bullet_inst)


func _on_better_thrusters_pressed():
	if Global.money >= Global.thrust_price:
		match player.type:
			"offender":
				Global.offforce -= 1000
			"handyman":
				Global.handforce -= 1000
			"cruisedriller":
				Global.drilforce -= 1000
		player.force -= 1000
		player.deduct_money(Global.thrust_price)
		Global.thrust_price += 500
		$uppgrades/upgrades/VBoxContainer/PanelContainer/Label.text = str(Global.thrust_price) + " credits"
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"


func _on_better_armor_pressed():
	if Global.money >= Global.armor_price:
		match player.type:
			"offender":
				Global.offmaxhp += 10
				Global.offhp = Global.offmaxhp
			"handyman":
				Global.handmaxhp += 10
				Global.handhp = Global.handmaxhp
			"cruisedriller":
				Global.drilmaxhp += 10
				Global.drilhp = Global.drilmaxhp
		player.maxhp += 10
		player.repair()
		player.deduct_money(Global.armor_price)
		Global.armor_price += 500
		$uppgrades/upgrades/VBoxContainer/PanelContainer2/Label.text = str(Global.armor_price) + " credits"
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"

func _on_iffchange_pressed():
	if Global.money >= 500:
		Global.reputation = 10
		player.reputation = 10
		player.deduct_money(500)
		$RichTextLabel.text = "done"
	else:
		$RichTextLabel.text = "you cant afford that, sorry"
	





