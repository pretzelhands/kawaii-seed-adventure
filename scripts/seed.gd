class_name PlayerSeed

extends RigidBody2D

var tree: SceneTree
var camera: Camera2D
var sprite: AnimatedSprite

var screen_top
var screen_bottom
var screen_left
var screen_right

var is_off_screen = false
var has_hit_ground = false
var initial_tumble = false

func _ready():
	tree = get_tree()
	camera = get_parent().get_node("camera")
	sprite = get_node("sprite")
	
	self.set_linear_velocity(Vector2(0, 300))

func _process(delta):
	var camera_position = camera.get_camera_position()
	var camera_viewport = camera.get_viewport_rect().size
	
	screen_top = camera_position.y
	screen_bottom = camera_position.y + camera_viewport.y
	
	screen_left = camera_position.x
	screen_right = camera_position.x + camera_viewport.x
	
	if position.y < screen_top - 32 || position.y > screen_bottom + 32:
		is_off_screen = true
	
	if position.x < screen_left - 32 || position.x > screen_right + 32:
		is_off_screen = true

func _integrate_forces(state):
	if (!initial_tumble):
		var initial_impulse = rand_range(-1000, 1000)
		
		state.apply_impulse(Vector2(0, 0), Vector2(initial_impulse / 4, 0))
		state.apply_torque_impulse(initial_impulse)
		initial_tumble = true
	
	var impulse_strength = rand_range(300, 400)
	
	if Input.is_action_just_pressed("ui_left"):
		state.apply_torque_impulse(impulse_strength * 4 * -1)
		state.apply_impulse(Vector2(0, 0), Vector2(impulse_strength  /2 * -1, 50))
	elif Input.is_action_just_pressed("ui_right"):
		state.apply_torque_impulse(impulse_strength * 4)
		state.apply_impulse(Vector2(0, 0), Vector2(impulse_strength / 2, 50))
	elif Input.is_action_just_pressed("ui_down"):
		state.apply_impulse(Vector2(0, 0), Vector2(0, 200))
	elif Input.is_action_just_pressed("ui_up"):
		state.apply_impulse(Vector2(0, 0), Vector2(0, -impulse_strength))



func _on_seed_collision(body):
	if (body.is_in_group("ground")):	
		self.has_hit_ground = true
		self.set_sleeping(true)
