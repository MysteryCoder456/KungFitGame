extends Node2D


func _ready():
	visible = OS.get_name() in ["iOS", "Android", "UWP"]


func _on_StickAttackButton_pressed():
	var e = InputEventAction.new()
	e.action = "stick_attack"
	e.pressed = true
	Input.parse_input_event(e)

func _on_StickAttackButton_released():
	var e = InputEventAction.new()
	e.action = "stick_attack"
	e.pressed = false
	Input.parse_input_event(e)


func _on_KickAttackButton_pressed():
	var e = InputEventAction.new()
	e.action = "kick_attack"
	e.pressed = true
	Input.parse_input_event(e)

func _on_KickAttackButton_released():
	var e = InputEventAction.new()
	e.action = "kick_attack"
	e.pressed = false
	Input.parse_input_event(e)
