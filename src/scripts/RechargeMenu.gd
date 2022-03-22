extends Control

const MAIN_MENU_SCENE = "res://src/scenes/MainMenu.tscn"

onready var anim_player: AnimationPlayer = $AnimationPlayer


func _process(delta):
	var accel = get_accelerometer()
	var accel_mag = accel.length()
	print(accel_mag)


func get_accelerometer() -> Vector3:
	var os_name = OS.get_name()
	
	if os_name in ["iOS", "UWP"]:
		return 9.81 * (Input.get_accelerometer() - Input.get_gravity())
	elif os_name == "Android":
		return Input.get_accelerometer() - Input.get_gravity()
	
	return Vector3.ZERO


func _on_GoBackButton_pressed():
	anim_player.play("Fade Out")


func _on_EnergySaveTimer_timeout():
	GameData.save_game_data()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene(MAIN_MENU_SCENE)
