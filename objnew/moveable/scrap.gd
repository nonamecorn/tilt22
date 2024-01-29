extends Part

var init_texture: Texture
var frame = 0;
var frames = [0,0]

func _ready():
	$Sprite2D.texture = init_texture
	$Sprite2D.frame = frame
