extends Control

const MAIN_MENU_SCENE = "res://src/scenes/MainMenu.tscn"

onready var anim_player: AnimationPlayer = $AnimationPlayer


func _process(delta):
	# TODO: Add energy recharge functionality
	pass


func _on_GoBackButton_pressed():
	anim_player.play("Fade Out")


func _on_EnergySaveTimer_timeout():
	GameData.save_game_data()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade Out":
		get_tree().change_scene(MAIN_MENU_SCENE)
