extends KinematicBody2D

const DIRECTION_STRINGS = ["up", "down", "horizontal"]
enum Direction {
	UP = 0
	DOWN = 1
	HORIZONTAL = 2
}

enum State {
	RUNNING,
	ATTACKING
}

export var speed: float

var velocity = Vector2.ZERO
var direction = Direction.DOWN
var state = State.RUNNING

onready var animated_sprite = $AnimatedSprite

func _physics_process(delta: float):
	velocity = Vector2.DOWN * speed  # get_movement_vel()

	if velocity.y < 0:
		direction = Direction.UP
	elif velocity.y > 0:
		direction = Direction.DOWN
	elif velocity.x < 0:
		direction = Direction.HORIZONTAL
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		direction = Direction.HORIZONTAL
		animated_sprite.flip_h = false

	var dir_str = DIRECTION_STRINGS[direction]

	match state:
		State.RUNNING:
			animated_sprite.play("running_%s" % dir_str)

	velocity = move_and_slide(velocity)
