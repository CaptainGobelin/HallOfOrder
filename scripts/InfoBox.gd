extends Node2D

func _ready():
	Signals.connect("language_changed", self, "updateTranslations")
	updateTranslations()
	hideTooltip()
	unroll()

func updateTranslations():
	$TextContainer/Label.text = tr("GAME_HELP")

func showTooltip(type: int):
	$Tooltip/TooltipFactory.visible = true
	$Tooltip/TextContainer.visible = false
	$Tooltip/TooltipFactory.setType(type)

func hideTooltip():
	$Tooltip/TooltipFactory.visible = true
	$Tooltip/TextContainer.visible = false
	$Tooltip/TooltipFactory.setType(TooltipFactory.tooltips.Tuto)

func setTooltip(message: String):
	$Tooltip/TooltipFactory.visible = false
	$Tooltip/TextContainer.visible = true
	$Tooltip/TextContainer/Label.text  = message

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
