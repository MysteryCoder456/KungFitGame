extends Control

const WORLD_SCENE = preload("res://src/scenes/World.tscn")
const RECHARGE_SCENE = preload("res://src/scenes/RechargeMenu.tscn")
const ENERGY_REQUIREMENT = 100

export var scroll_start_position: Vector2
export var scroll_end_position: Vector2

onready var background: Node2D = $BackgroundTilemaps
onready var energy_label: Label = $H/EnergyLabel
onready var low_energy_label: Label = $V/LowEnergyLabel
onready var play_button: Button = $V/Buttons/PlayButton
onready var scroll_timer: Timer = $ScrollTimer
onready var anim_player: AnimationPlayer = $AnimationPlayer

var next_scene: PackedScene


func _ready():
	energy_label.text = str(round(GameData.energy))
	
	play_button.disabled = GameData.energy < ENERGY_REQUIREMENT
	low_energy_label.visible = GameData.energy < ENERGY_REQUIREMENT
	low_energy_label.text = "You need at least\n%s energy to play!" % ENERGY_REQUIREMENT
	
	anim_player.play("RESET")


func _process(delta):
	background.global_position = lerp(scroll_end_position, scroll_start_position, scroll_timer.time_left / scroll_timer.wait_time)


func _on_PlayButton_pressed():
	next_scene = WORLD_SCENE
	anim_player.play("Fade Out")


func _on_RechargeButton_pressed():
	next_scene = RECHARGE_SCENE
	anim_player.play("Fade Out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene_to(next_scene)
