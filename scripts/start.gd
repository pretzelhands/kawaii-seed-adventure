extends Node2D

var MainScene = preload("res://scenes/main.tscn")

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to(MainScene)
