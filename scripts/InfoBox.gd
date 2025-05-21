extends Node2D


func colorize():
	var color = Utils.getBiomeColor()
	$TileMap.modulate = color
	$Sprite.modulate = color
