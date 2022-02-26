extends Node2D

const ENEMY_SCENE = preload("res://src/actors/Enemy.tscn")

onready var nav = $Navigation2D
onready var actors = $Actors
onready var player = $Actors/KungFuMan


func _ready():
	# TODO: Add wave system
	var new_enemy = ENEMY_SCENE.instance()
	new_enemy.init(player, nav)
	actors.add_child(new_enemy)
	new_enemy.position = Vector2(150, 50)


func _on_NavUpdateTimer_timeout():
	get_tree().call_group("Enemy", "get_path_to_target")
