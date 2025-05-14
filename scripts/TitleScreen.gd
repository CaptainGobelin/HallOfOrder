extends Node2D

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	Utils.changeScene("res://scenes/LevelSelector.tscn")
