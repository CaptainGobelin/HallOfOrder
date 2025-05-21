tool
extends Node2D

func _ready():
	Ref.heroes = get_node("Heroes")

func colorize():
	var color = Utils.getBiomeColor()
	$TileMap.modulate = color
	$Frame.modulate = color

func _on_TextureButton_pressed():
	MouseHandler.normalMode()
