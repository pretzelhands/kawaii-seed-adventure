extends KinematicBody2D

export (int) var GRAVITY
export (int) var MAX_VELOCITY

var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var motion = velocity * delta
	
	move_and_collide(motion)
	
