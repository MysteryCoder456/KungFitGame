extends Control

export var scroll_start_position: Vector2
export var scroll_end_position: Vector2

onready var scroll_timer = $ScrollTimer
onready var background = $BackgroundTilemaps


func _process(delta):
	background.global_position = lerp(scroll_end_position, scroll_start_position, scroll_timer.time_left / scroll_timer.wait_time)
