extends Node2D

const ENEMY_SCENE = preload("res://src/actors/Enemy.tscn")
const ENEMY_POSITION_LIMIT = Vector2(664, 470)

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
		var global_pos = player.global_position + offset
		
		# Keep position within land area
		
		if abs(global_pos.x) > ENEMY_POSITION_LIMIT.x:
			var x_off_dir = abs(global_pos.x) / global_pos.x
			global_pos.x -= (abs(global_pos.x) - ENEMY_POSITION_LIMIT.x) * x_off_dir
		
		if abs(global_pos.y) > ENEMY_POSITION_LIMIT.y:
			var y_off_dir = abs(global_pos.y) / global_pos.y
			global_pos.y -= (abs(global_pos.y) - ENEMY_POSITION_LIMIT.y) * y_off_dir
		
		var new_enemy = ENEMY_SCENE.instance()
		new_enemy.init(player, nav)
		entities.add_child(new_enemy)
		new_enemy.global_position = global_pos
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
	get_tree().paused = false
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")
