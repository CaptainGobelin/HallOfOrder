extends Node2D

func _ready():
	hideTooltip()
	unroll()

func showTooltip(type: int):
	$Tooltip/TooltipFactory.visible = true
	$Tooltip/TooltipFactory.setType(type)

func hideTooltip():
	$Tooltip/TooltipFactory.visible = false

func colorize():
	var color = Utils.getBiomeColor()
	$TileMap.modulate = color
	$Rolled.modulate = color
	$Sprite.modulate = color
	$RollButton.modulate = color
	$UnrollButton.modulate = color
	$Tooltip/TooltipFactory.colorize()

func roll():
	$TileMap.visible = false
	$Rolled.visible = true
	$Tooltip.visible = false
	$RollButton.visible = false
	$UnrollButton.visible = true

func unroll():
	$TileMap.visible = true
	$Rolled.visible = false
	$Tooltip.visible = true
	$RollButton.visible = true
	$UnrollButton.visible = false
