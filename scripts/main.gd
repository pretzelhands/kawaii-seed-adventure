extends Node

const GROUND_POSITION = 11_024

enum GameState {
	RUNNING,
	GAME_OVER,
	END
}

var Seed = preload("res://scenes/entities/seed.tscn")
var GrassBlade = preload("res://scenes/entities/grass_blade.tscn")
var LeafyBit = preload("res://scenes/entities/leafy_bit.tscn")
var Lavender = preload("res://scenes/entities/lavender.tscn")
var Ground = preload("res://scenes/entities/ground.tscn")
var Root = preload("res://scenes/entities/root.tscn")

var possible_obstacles = [
	GrassBlade,
	LeafyBit,
	Lavender,
]

var current_state = GameState.RUNNING
var game_over_spawned = false
var root_spawned = false
var ground_spawned = false
var ground_row = []

var player_seed: PlayerSeed
var camera: Camera2D
var spawn_timer: Timer
var end_timer: Timer
var end_text: Sprite
var game_over_text: Sprite

func _ready():
	for i in 16:
		var new_ground = Ground.instance()
		new_ground.position.x = (40 * i) + 24
		
		ground_row.append(new_ground)
	
	
	camera = get_node("camera")
	end_timer = get_node("end_timer")
	end_text = get_node("end_text")
	game_over_text = get_node("game_over_text")
	
	spawn_timer = get_node("spawn_timer")
	spawn_timer.start()
	
	player_seed = Seed.instance()
	player_seed.position = Vector2(320, 32)
	
	add_child(player_seed)


func _process(delta):
	if player_seed.is_off_screen:
		current_state = GameState.GAME_OVER
		
	if current_state == GameState.GAME_OVER and !game_over_spawned:
		game_over_text.position.x = 320
		game_over_text.position.y = camera.position.y + 512
		game_over_text.z_index = 200
		game_over_text.visible = true
		game_over_spawned = true
		
	if current_state == GameState.GAME_OVER and Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()
	
	if current_state == GameState.RUNNING:
		camera.position.y += 3
		
	if player_seed.has_hit_ground and current_state != GameState.END:
		current_state = GameState.END
		root_spawned = true
		
		var root = Root.instance()
		root.position.y = GROUND_POSITION + 48
		root.position.x = player_seed.position.x
		root.play("grow")
		add_child(root)
		
		end_timer.start()


func _on_spawn_timer_tick():	
	if camera.position.y > (10_000 - 128) and !ground_spawned:
		ground_spawned = true
		spawn_timer.stop()
		
		for ground in ground_row:
			ground.position.y = GROUND_POSITION
			add_child(ground)
	
	var random_index = randi() % possible_obstacles.size()
	var new_obstacle = possible_obstacles[random_index].instance()
	
	new_obstacle.z_index = 3
	if (new_obstacle.position.y < 10_000):
		add_child(new_obstacle)


func _on_end_timer_tick():
	end_text.position.x = 320
	end_text.position.y = camera.position.y + 248
	end_text.visible = true
