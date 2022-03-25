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
