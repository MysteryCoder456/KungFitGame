class_name KungFuMan
extends KinematicBody2D

const DIRECTION_STRINGS = ["up", "down", "left", "right"]
enum Direction {
	UP = 0
	DOWN = 1
	LEFT = 2
	RIGHT = 3
}

enum State {
	IDLE
	RUNNING
}

export var speed: float

var velocity = Vector2.ZERO
var direction = Direction.DOWN
var state = State.IDLE

onready var animated_sprite = $AnimatedSprite
onready var hud = $CanvasLayer/HUD


func _physics_process(delta: float):
	velocity = get_movement_vel()

	if velocity.y < 0:
		direction = Direction.UP
	elif velocity.y > 0:
		direction = Direction.DOWN
	elif velocity.x < 0:
		direction = Direction.LEFT
	elif velocity.x > 0:
		direction = Direction.RIGHT

	var dir_str = DIRECTION_STRINGS[direction]

	match state:
		State.IDLE:
			if velocity != Vector2.ZERO:
				state = State.RUNNING

			animated_sprite.play("idle_%s" % dir_str)

		State.RUNNING:
			if velocity == Vector2.ZERO:
				state = State.IDLE

			animated_sprite.play("running_%s" % dir_str)
			velocity = move_and_slide(velocity)


func get_movement_vel() -> Vector2:
	var new_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		new_velocity = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		new_velocity = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		new_velocity = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		new_velocity = Vector2.RIGHT

	new_velocity *= speed
	return new_velocity
