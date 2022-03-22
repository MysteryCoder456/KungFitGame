extends Node2D


func _ready():
	visible = OS.get_name() in ["iOS", "Android", "UWP"]


func _on_UpButton_pressed():
	var e = InputEventAction.new()
	e.action = "move_up"
	e.pressed = true
	Input.parse_input_event(e)

func _on_UpButton_released():
	var e = InputEventAction.new()
	e.action = "move_up"
	e.pressed = false
	Input.parse_input_event(e)


func _on_DownButton_pressed():
	var e = InputEventAction.new()
	e.action = "move_down"
	e.pressed = true
	Input.parse_input_event(e)

func _on_DownButton_released():
	var e = InputEventAction.new()
	e.action = "move_down"
	e.pressed = false
	Input.parse_input_event(e)


func _on_LeftButton_pressed():
	var e = InputEventAction.new()
	e.action = "move_left"
	e.pressed = true
	Input.parse_input_event(e)

func _on_LeftButton_released():
	var e = InputEventAction.new()
	e.action = "move_left"
	e.pressed = false
	Input.parse_input_event(e)


func _on_RightButton_pressed():
	var e = InputEventAction.new()
	e.action = "move_right"
	e.pressed = true
	Input.parse_input_event(e)

func _on_RightButton_released():
	var e = InputEventAction.new()
	e.action = "move_right"
	e.pressed = false
	Input.parse_input_event(e)
