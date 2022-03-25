extends Control

const MAIN_MENU_SCENE = "res://src/scenes/MainMenu.tscn"
const UPGRADE_STEP = 0.15
const HEALTH_COST_FACTOR = 30
const STRENGTH_COST_FACTOR = 20

onready var coins_label: Label = $V/CoinsHBox/CoinsLabel

onready var health_multiplier_label: Label = $V/H1/V1/HealthMultiplierLabel
onready var health_cost_label: Label = $V/H1/V1/HealthCostLabel

onready var strength_multiplier_label: Label = $V/H1/V2/StrengthMultiplierLabel
onready var strength_cost_label: Label = $V/H1/V2/StrengthCostLabel

onready var health_upgrade_button: Button = $V/H1/V1/H2/HealthUpgradeButton
onready var strength_upgrade_button: Button = $V/H1/V2/H2/StrengthUpgradeButton
onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var button_audio_player: AudioStreamPlayer = $ButtonAudioPlayer
onready var upgrade_audio_player: AudioStreamPlayer = $UpgradeAudioPlayer


func _ready():
	coins_label.text = str(GameData.coins)
	
	update_health_gui()
	update_strength_gui()


func get_health_cost() -> int:
	return int(round(GameData.health_multiplier * HEALTH_COST_FACTOR))


func get_strength_cost() -> int:
	return int(round(GameData.strength_multiplier * STRENGTH_COST_FACTOR))


func update_health_gui():
	health_multiplier_label.text = "x%s" % GameData.health_multiplier
	health_cost_label.text = "Cost: %s" % get_health_cost()
	health_upgrade_button.disabled = get_health_cost() >= GameData.coins


func update_strength_gui():
	strength_multiplier_label.text = "x%s" % GameData.strength_multiplier
	strength_cost_label.text = "Cost: %s" % get_strength_cost()
	strength_upgrade_button.disabled = get_strength_cost() >= GameData.coins


func _on_HealthUpgradeButton_pressed():
	var cost = get_health_cost()
	
	if GameData.coins < cost:
		return
	
	GameData.coins -= cost
	GameData.health_multiplier += UPGRADE_STEP
	
	coins_label.text = str(GameData.coins)
	update_health_gui()
	update_strength_gui()
	upgrade_audio_player.play()


func _on_StrengthUpgradeButton_pressed():
	var cost = get_strength_cost()
	
	if GameData.coins < cost:
		return
	
	GameData.coins -= cost
	GameData.strength_multiplier += UPGRADE_STEP
	
	coins_label.text = str(GameData.coins)
	update_health_gui()
	update_strength_gui()
	upgrade_audio_player.play()


func _on_GoBackButton_pressed():
	GameData.save_game_data()
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene(MAIN_MENU_SCENE)
