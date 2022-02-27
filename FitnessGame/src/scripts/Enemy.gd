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
export var attack_damage_min: float
export var attack_damage_max: float

var velocity = Vector2.ZERO
var direction = Direction.DOWN
var state = State.RUNNING
var pathfinding_threshold = 16
var target: KungFuMan
var nav: Navigation2D
var path = []

onready var animated_sprite = $AnimatedSprite
onready var attack_timer = $AttackTimer


func init(_target: KungFuMan, _nav: Navigation2D):
	target = _target
	nav = _nav


func _physics_process(delta: float):
	velocity = get_movement_vel()

	if velocity.y < 0:
		direction = Direction.UP
	elif velocity.y > 0:
		direction = Direction.DOWN
	else:
		direction = Direction.HORIZONTAL

	if velocity.x < 0:
		animated_sprite.set_flip_h(true)
	elif velocity.x > 0:
		animated_sprite.set_flip_h(false)

	var dir_str = DIRECTION_STRINGS[direction]

	match state:
		State.ATTACKING:
			if global_position.distance_to(target.global_position) <= pathfinding_threshold:
				if attack_timer.is_stopped():
					attack_timer.start()
				animated_sprite.play("attacking")
			else:
				state = State.RUNNING

		State.RUNNING:
			if global_position.distance_to(target.global_position) <= pathfinding_threshold:
				do_damage_to_target()
				state = State.ATTACKING

			velocity = move_and_slide(velocity)
			animated_sprite.play("running_%s" % dir_str)


func get_movement_vel() -> Vector2:
	if path.size() > 0:
		if global_position.distance_to(path[0]) < pathfinding_threshold:
			path.remove(0)
			return velocity
		else:
			var direction = global_position.direction_to(path[0])
			return direction * speed

	return Vector2.ZERO


func get_path_to_target():
	path = nav.get_simple_path(global_position, target.global_position)


func do_damage_to_target():
	var damage_value = lerp(attack_damage_min, attack_damage_max, randf())
	target.damage(damage_value)


func _on_AttackTimer_timeout():
	if global_position.distance_to(target.global_position) <= pathfinding_threshold:
		do_damage_to_target()
