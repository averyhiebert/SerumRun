extends ParallaxBackground


export var stopped = false

var scroll_speed = Vector2(100,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	#scroll_offset = Vector2(0,0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not stopped:
		scroll_offset += scroll_speed * delta
