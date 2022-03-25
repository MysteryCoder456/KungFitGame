extends Control

const WORLD_SCENE = preload("res://src/scenes/World.tscn")
const RECHARGE_SCENE = preload("res://src/scenes/RechargeMenu.tscn")
const UPGRADE_SCENE = preload("res://src/scenes/UpgradeMenu.tscn")
const CREDITS_SCENE = preload("res://src/scenes/Credits.tscn")
const ENERGY_REQUIREMENT = 100

export var scroll_start_position: Vector2
export var scroll_end_position: Vector2

onready var background: Node2D = $BackgroundTilemaps
onready var energy_label: Label = $H/EnergyLabel
onready var coins_label: Label = $H/CoinsLabel
onready var low_energy_label: Label = $V/LowEnergyLabel
onready var play_button: Button = $V/Buttons/PlayButton
onready var scroll_timer: Timer = $ScrollTimer
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var button_audio_player: AudioStreamPlayer = $ButtonAudioPlayer

var next_scene: PackedScene


func _ready():
	energy_label.text = str(round(GameData.energy))
	coins_label.text = str(GameData.coins)
	
	play_button.disabled = GameData.energy < ENERGY_REQUIREMENT
	low_energy_label.visible = GameData.energy < ENERGY_REQUIREMENT
	low_energy_label.text = "You need at least\n%s energy to play!" % ENERGY_REQUIREMENT
	
	anim_player.play("RESET")


func _process(delta):
	background.global_position = lerp(scroll_end_position, scroll_start_position, scroll_timer.time_left / scroll_timer.wait_time)


func _on_PlayButton_pressed():
	next_scene = WORLD_SCENE
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_RechargeButton_pressed():
	next_scene = RECHARGE_SCENE
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_UpgradeButton_pressed():
	next_scene = UPGRADE_SCENE
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_CreditsButton_pressed():
	next_scene = CREDITS_SCENE
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene_to(next_scene)
