tool
extends Node2D

func _ready():
	Ref.heroes = get_node("Heroes")

func _on_TextureButton_pressed():
	MouseHandler.normalMode()
