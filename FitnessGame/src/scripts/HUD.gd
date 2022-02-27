extends Control

onready var health_bar: ProgressBar = $TopBar/HealthBar
onready var wave_label: Label = $TopBar/WaveLabel


func _ready():
	health_bar.value = health_bar.max_value
	wave_label.text = "Wave: 1"
