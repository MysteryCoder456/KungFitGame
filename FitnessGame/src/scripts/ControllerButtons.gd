extends Node2D


func _on_UpButton_pressed():
	Input.action_press("move_up")

func _on_UpButton_released():
	Input.action_release("move_up")


func _on_DownButton_pressed():
	Input.action_press("move_down")

func _on_DownButton_released():
	Input.action_release("move_down")


func _on_LeftButton_pressed():
	Input.action_press("move_left")

func _on_LeftButton_released():
	Input.action_release("move_left")


func _on_RightButton_pressed():
	Input.action_press("move_right")

func _on_RightButton_released():
	Input.action_release("move_right")
