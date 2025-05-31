tool
extends Node2D

export(Vector2) var size = Vector2(1, 1) setget setSize

func colorize():
	var color = Utils.getBiomeColor()
	$Light.modulate = color
	$Shadow.modulate = color
	$Block.modulate = color

func setSize(v: Vector2):
	size = v
	if not has_node("Block"):
		return
	$Light.margin_right = v.x * 45
	$Light.margin_bottom = v.y * 45
	$Shadow.margin_right = v.x * 45
	$Shadow.margin_bottom = v.y * 45
	$Block.margin_right = v.x * 45 - 2
	$Block.margin_bottom = v.y * 45 - 2
