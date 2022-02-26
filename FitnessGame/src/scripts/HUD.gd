extends Control

onready var health_bar = $TopBar/HealthBar
onready var wave_label = $TopBar/WaveLabel


func _ready():
	health_bar.value = health_bar.max_value
	wave_label.text = "Wave: 1"
