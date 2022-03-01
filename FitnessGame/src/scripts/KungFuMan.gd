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
	RUNNING,
	STICKING,
	KICKING
}

export var speed: float
export var raw_max_health: float  # Base health value to modify with multiplier upgrades
export var health_multiplier: float  # TODO: Make this an upgrade later

var velocity = Vector2.ZERO
var direction = Direction.DOWN
var state = State.IDLE

var enemies_above: Array = []
var enemies_below: Array = []
var enemies_on_right: Array = []
var enemies_on_left: Array = []

onready var actual_max_health = raw_max_health * health_multiplier
onready var health = actual_max_health

onready var animated_sprite = $AnimatedSprite
onready var hud = $CanvasLayer/HUD


func _input(event: InputEvent):
	if event.is_action_pressed("stick_attack"):
		stick_attack()
	elif event.is_action_pressed("kick_attack"):
		kick_attack()


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


func damage(damage_amount: float):
	health -= damage_amount
	var bar_value = lerp(0, hud.health_bar.max_value, health / actual_max_health)
	hud.set_health_bar_value(bar_value)


func stick_attack():
	# TODO
	state = State.STICKING


func kick_attack():
	# TODO
	state = State.KICKING


func _on_UpEnemyDetector_body_entered(body: Enemy):
	enemies_above.append(body)

func _on_UpEnemyDetector_body_exited(body: Enemy):
	enemies_above.erase(body)


func _on_DownEnemyDetector_body_entered(body: Enemy):
	enemies_below.append(body)

func _on_DownEnemyDetector_body_exited(body: Enemy):
	enemies_below.erase(body)


func _on_LeftEnemyDetector_body_entered(body: Enemy):
	enemies_on_left.append(body)

func _on_LeftEnemyDetector_body_exited(body: Enemy):
	enemies_on_left.erase(body)


func _on_RightEnemyDetector_body_entered(body: Enemy):
	enemies_on_right.append(body)

func _on_RightEnemyDetector_body_exited(body: Enemy):
	enemies_on_right.erase(body)
