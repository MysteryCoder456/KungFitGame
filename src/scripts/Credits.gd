extends Control

const MAIN_MENU_SCENE = "res://src/scenes/MainMenu.tscn"

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var button_audio_player: AudioStreamPlayer = $ButtonAudioPlayer


func _on_GoBackButton_pressed():
	GameData.save_game_data()
	button_audio_player.play()
	anim_player.play("Fade Out")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene(MAIN_MENU_SCENE)


func _on_ChasersGaming_pressed():
	OS.shell_open("https://chasersgaming.itch.io/")


func _on_pixelarchipel_pressed():
	OS.shell_open("https://www.patreon.com/pixelarchipel")


func _on_Kenney_pressed():
	OS.shell_open("https://kenney.nl/")


func _on_zedseven_pressed():
	OS.shell_open("https://github.com/zedseven/Pixellari")
