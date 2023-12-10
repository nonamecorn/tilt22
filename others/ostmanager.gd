extends Node
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	play()
func play():
	get_child(rng.randi_range(0,get_children().size() - 1)).play()


func _on_song_finished():
	play()

