extends StaticBody2D
class_name OverworldObject
const SND_SELECT : AudioStream = preload("uid://bgxt15uqc5rs0")

func _on_player_action() :
	print("与可交互对象对话")
	GlobalSoundPlayer.play_sound(SND_SELECT)
	OverworldDialogManager.dialog_add("* Hello, welcome to Undertale!")
	OverworldDialogManager.dialog_start()
