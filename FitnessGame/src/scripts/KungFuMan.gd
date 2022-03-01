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

# Base values to modify with multiplier upgrades
export var raw_max_health: float
export var raw_strength: float
export var raw_regeneration_rate: float

# TODO: Make these upgrades later
export var health_multiplier: float
export var strength_multiplier: float
export var regeneration_multiplier: float

var velocity = Vector2.ZERO
var direction = Direction.DOWN
var state = State.IDLE
var enemies = [[], [], [], []]  # Array of arrays for each direction

onready var actual_max_health = raw_max_health * health_multiplier
onready var health = actual_max_health

onready var actual_strength = raw_strength * strength_multiplier
onready var actual_regen_rate = raw_regeneration_rate * regeneration_multiplier

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var hud: PlayerHUD = $CanvasLayer/HUD
onready var attack_timer: Timer = $AttackTimer


func _input(event: InputEvent):
	if attack_timer.is_stopped():
		if event.is_action_pressed("stick_attack"):
			stick_attack()
		elif event.is_action_pressed("kick_attack"):
			kick_attack()


func _physics_process(delta: float):
	heal(actual_regen_rate * delta)
	velocity = get_movement_vel()
	var dir_str = DIRECTION_STRINGS[direction]

	match state:
		State.IDLE:
			if velocity != Vector2.ZERO:
				state = State.RUNNING

			animated_sprite.play("idle_%s" % dir_str)

		State.RUNNING:
			if velocity == Vector2.ZERO:
				state = State.IDLE

			if velocity.y < 0:
				direction = Direction.UP
			elif velocity.y > 0:
				direction = Direction.DOWN
			elif velocity.x < 0:
				direction = Direction.LEFT
			elif velocity.x > 0:
				direction = Direction.RIGHT

			animated_sprite.play("running_%s" % dir_str)
			velocity = move_and_slide(velocity)

		State.STICKING:
			animated_sprite.play("stick_attack_%s" % dir_str)

		State.KICKING:
			animated_sprite.play("kick_attack_%s" % dir_str)


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


func heal(amount: float):
	damage(-amount)
	health = min(health, actual_max_health)


func damage(damage_amount: float):
	health -= damage_amount
	var bar_value = lerp(0, hud.health_bar.max_value, health / actual_max_health)
	hud.set_health_bar_value(bar_value)


func stick_attack():
	var kb_dir: Vector2

	match direction:
		Direction.UP:
			kb_dir = Vector2.UP
		Direction.DOWN:
			kb_dir = Vector2.DOWN
		Direction.LEFT:
			kb_dir = Vector2.LEFT
		Direction.RIGHT:
			kb_dir = Vector2.RIGHT

	for enemy in enemies[direction]:
		enemy.damage(actual_strength, kb_dir, 1)

	state = State.STICKING
	attack_timer.start()


func kick_attack():
	var kb_dir: Vector2

	match direction:
		Direction.UP:
			kb_dir = Vector2.UP
		Direction.DOWN:
			kb_dir = Vector2.DOWN
		Direction.LEFT:
			kb_dir = Vector2.LEFT
		Direction.RIGHT:
			kb_dir = Vector2.RIGHT

	for enemy in enemies[direction]:
		# Kick does twice the damage as stick but leaves
		# the player vulnerable to attacks for longer
		enemy.damage(actual_strength * 2, kb_dir, 1.5)

	state = State.KICKING
	attack_timer.start()


func _on_UpEnemyDetector_body_entered(body: Enemy):
	enemies[Direction.UP].append(body)

func _on_UpEnemyDetector_body_exited(body: Enemy):
	enemies[Direction.UP].erase(body)


func _on_DownEnemyDetector_body_entered(body: Enemy):
	enemies[Direction.DOWN].append(body)

func _on_DownEnemyDetector_body_exited(body: Enemy):
	enemies[Direction.DOWN].erase(body)


func _on_LeftEnemyDetector_body_entered(body: Enemy):
	enemies[Direction.LEFT].append(body)

func _on_LeftEnemyDetector_body_exited(body: Enemy):
	enemies[Direction.LEFT].erase(body)


func _on_RightEnemyDetector_body_entered(body: Enemy):
	enemies[Direction.RIGHT].append(body)

func _on_RightEnemyDetector_body_exited(body: Enemy):
	enemies[Direction.RIGHT].erase(body)


func _on_AnimatedSprite_animation_finished():
	if state == State.STICKING or State.KICKING:
		state = State.IDLE
