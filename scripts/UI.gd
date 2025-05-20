extends Node2D
class_name Ui

func _ready():
	Ref.ui = self

func _on_MenuButton_pressed():
	#TODO this is a temp behavior
	Utils.changeScene("res://scenes/TitleScreen.tscn")
