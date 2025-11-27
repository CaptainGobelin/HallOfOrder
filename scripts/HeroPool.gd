tool
extends Node2D

func _ready():
#	Ref.heroes = get_node("Heroes")
	Signals.connect("language_changed", self, "updateTranslations")
	updateTranslations()

func colorize():
	var color = Utils.getBiomeColor()
	$TileMap.modulate = color
	$Frame.modulate = color

func updateTranslations():
	$TextContainer/Label.text = tr("GAME_HEROES")

func _on_TextureButton_pressed():
	MouseHandler.normalMode()
