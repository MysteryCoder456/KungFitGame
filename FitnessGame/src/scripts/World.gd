extends Node2D

const ENEMY_SCENE = preload("res://src/actors/Enemy.tscn")

var wave = 0;

onready var nav: Navigation2D = $Navigation2D
onready var entities: YSort = $Entities
onready var player: KungFuMan = $Entities/KungFuMan


func _ready():
	get_tree().call_group("HUD", "set_wave_number", wave)


func spawn_enemies():
	var enemy_count = ceil(wave * 1.5)
	var circle_radius = 75
	var angle_step = TAU / enemy_count
	var angle = 0

	for i in range(enemy_count):
		var offset = Vector2(cos(angle), sin(angle)) * circle_radius
		var new_enemy = ENEMY_SCENE.instance()
		new_enemy.init(player, nav)
		entities.add_child(new_enemy)
		new_enemy.global_position = player.global_position + offset
		angle += angle_step


func next_wave():
	wave += 1
	get_tree().call_group("HUD", "set_wave_number", wave)
	get_tree().call_group("HUD", "do_wave_animation")
	spawn_enemies()


func _on_NavUpdateTimer_timeout():
	get_tree().call_group("Enemy", "get_path_to_target")


func _on_WaveUpdateTimer_timeout():
	if not get_tree().get_nodes_in_group("Enemy"):
		next_wave()


func _on_GameDataSaveTimer_timeout():
	GameData.save_game_data()


func _on_KungFuMan_death():
	GameData.save_game_data()
	get_tree().paused = true
	yield(get_tree().create_timer(5), "timeout")
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")
