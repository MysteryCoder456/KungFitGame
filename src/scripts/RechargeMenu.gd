extends Control

const MAIN_MENU_SCENE = "res://src/scenes/MainMenu.tscn"
const ACCELERATION_THRESHOLD = 7  # m/s^2
const ENERGY_GAIN_FACTOR = 0.001
const MAX_ENERGY_GAIN = 1.15

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var button_audio_player: AudioStreamPlayer = $ButtonAudioPlayer


func _process(delta):
	var accel = get_accelerometer()
	var accel_mag = accel.length()
	
	if accel_mag > ACCELERATION_THRESHOLD:
		var energy_gain = min((accel_mag - ACCELERATION_THRESHOLD) * ENERGY_GAIN_FACTOR, MAX_ENERGY_GAIN)
		GameData.energy += energy_gain
#		print("Gained %s energy" % energy_gain)


func get_accelerometer() -> Vector3:
	var os_name = OS.get_name()
	
	if os_name in ["iOS", "UWP"]:
		return 9.81 * (Input.get_accelerometer() - Input.get_gravity())
	elif os_name == "Android":
		return Input.get_accelerometer() - Input.get_gravity()
	else:
		# Simulate exercise on platforms that don't have an accelerometer
		return Vector3.FORWARD * 20


func _on_GoBackButton_pressed():
	GameData.save_game_data()
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_EnergySaveTimer_timeout():
	GameData.save_game_data()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene(MAIN_MENU_SCENE)
