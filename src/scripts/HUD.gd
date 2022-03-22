class_name PlayerHUD
extends Control

onready var health_bar: ProgressBar = $TopBar/HealthBar
onready var wave_label: Label = $TopBar/LabelsV/WaveLabel
onready var large_wave_label: Label = $LargeWaveLabel
onready var game_over_label: Label = $GameOverLabel
onready var energy_label: Label = $TopBar/LabelsV/H/EnergyLabel
onready var health_anim_timer: Timer = $HealthAnimationTimer
onready var health_anim_values = [health_bar.max_value, health_bar.max_value]


func _ready():
	large_wave_label.visible = false
	game_over_label.visible = false
	health_bar.value = health_bar.max_value


func _process(delta):
	energy_label.text = str(max(round(GameData.energy), 0))
	var time_left = health_anim_timer.time_left

	if time_left:
		var before_anim_value = health_anim_values[0]
		var after_anim_value = health_anim_values[1]

		var anim_value = lerp(after_anim_value, before_anim_value, time_left / health_anim_timer.wait_time)
		health_bar.set_value(anim_value)


func set_wave_number(wave_num: int):
	wave_label.text = "Wave: %s" % wave_num
	large_wave_label.text = "Wave %s" % wave_num


func do_wave_animation():
	# Add particles and sounds to this
	large_wave_label.visible = true
	yield(get_tree().create_timer(3), "timeout")
	large_wave_label.visible = false


func set_health_bar_value(value: float):
	health_anim_values = [health_bar.value, value]
	health_anim_timer.start()


func game_over():
	if GameData.energy <= 0:
		game_over_label.text = "No Energy!"
	else:
		game_over_label.text = "Game Over!"
	
	large_wave_label.visible = false
	game_over_label.visible = true
