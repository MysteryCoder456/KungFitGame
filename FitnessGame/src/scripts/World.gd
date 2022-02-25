extends Node2D

const ENEMY_SCENE = preload("res://src/actors/Enemy.tscn")

onready var nav = $Navigation2D
onready var player = $KungFuMan
onready var enemies = $Enemies


func _ready():
	var new_enemy = ENEMY_SCENE.instance()
	new_enemy.init(player, nav)
	enemies.add_child(new_enemy)
	new_enemy.position = Vector2(150, 50)


func _on_NavUpdateTimer_timeout():
	get_tree().call_group("Enemy", "get_path_to_target")
