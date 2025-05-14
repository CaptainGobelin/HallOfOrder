extends Node2D

func _ready():
	$TextContainer/Label.text = "Current version: v"
	$TextContainer/Label.text += String(VersionControl.CURRENT_VERSION)

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	Utils.changeScene("res://scenes/LevelSelector.tscn")
