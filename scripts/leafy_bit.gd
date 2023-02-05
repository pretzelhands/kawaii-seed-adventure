extends StaticBody2D

var camera: Camera2D
var sprite: Sprite

func _ready():
	camera = get_parent().get_node("camera")
	sprite = get_node("sprite")
	
	var spawn_x: float
	var side_probability = rand_range(0, 1) > 0.5
	var viewport = camera.get_viewport_rect()
	
	if side_probability:
		spawn_x = viewport.size.x - 80
	else:
		spawn_x = 80
		
	self.rotation_degrees = rand_range(-45, 45)
	self.position = Vector2(spawn_x, camera.position.y + viewport.size.y + sprite.texture.get_height())
	
	sprite.flip_h = side_probability
