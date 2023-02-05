extends StaticBody2D

var camera: Camera2D
var sprite: Sprite

func _ready():
	camera = get_parent().get_node("camera")
	sprite = get_node("sprite")
	
	var spawn_x: float
	var spawn_rotation: float
	
	var side_probability = rand_range(0, 1) > 0.5
	var viewport = camera.get_viewport_rect()
	
	if side_probability:
		spawn_x = viewport.size.x - 64
		spawn_rotation = rand_range(-45, 0)
	else:
		spawn_rotation = rand_range(0, 45)
		spawn_x = 64
		
	self.rotation_degrees = spawn_rotation
	self.position = Vector2(spawn_x, camera.position.y + viewport.size.y + (sprite.texture.get_height() * 2))
	
	sprite.flip_h = side_probability
