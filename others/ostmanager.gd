extends Node
var rng = RandomNumberGenerator.new()
var current_song_index = 0

func _ready():
	rng.randomize()
	playbgm()
func playbgm():
	if $bgm.get_children().size() == 0:
		print("no ost in node")
		return
	current_song_index = rng.randi_range(0,$bgm.get_children().size() - 1)
	$bgm.get_child(current_song_index).play()

func pause():
	$bgm.get_child(current_song_index).stream_paused = true

func resume():
	$bgm.get_child(current_song_index).stream_paused = false

func play(song_index):
	if $bgm.get_child(current_song_index).stream_paused: return
	for child in $bgm.get_children():
		child.stop()
	$ost.get_child(song_index).play()

func _on_song_finished():
	playbgm()

