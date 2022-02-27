extends Control

onready var health_bar: ProgressBar = $TopBar/HealthBar
onready var wave_label: Label = $TopBar/WaveLabel
onready var health_anim_timer: Timer = $HealthAnimationTimer
onready var health_anim_values = [health_bar.max_value, health_bar.max_value]


func _ready():
	health_bar.value = health_bar.max_value
	wave_label.text = "Wave: 1"


func _process(delta):
	var time_left = health_anim_timer.time_left

	if time_left:
		var before_anim_value = health_anim_values[0]
		var after_anim_value = health_anim_values[1]

		var anim_value = lerp(after_anim_value, before_anim_value, time_left / health_anim_timer.wait_time)
		health_bar.set_value(anim_value)


func set_health_bar_value(value: float):
	health_anim_values = [health_bar.value, value]
	health_anim_timer.start()
