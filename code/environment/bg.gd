extends ParallaxBackground

var speed = 15

func _process(delta: float) -> void:
	scroll_offset.x -= delta * speed
