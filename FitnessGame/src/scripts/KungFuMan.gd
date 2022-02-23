extends KinematicBody2D

var direction_strings = ["up", "down", "left", "right"]

enum Direction {
	UP = 0,
	DOWN = 1
	LEFT = 2
	RIGHT = 3
}

export var speed: float
var velocity = Vector2.ZERO
var direction = Direction.DOWN


func _physics_process(delta: float):
	velocity = get_movement_vel()
	velocity = move_and_slide(velocity)


func get_movement_vel() -> Vector2:
	var new_velocity = Vector2.ZERO

	new_velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	new_velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	new_velocity *= speed

	return new_velocity
