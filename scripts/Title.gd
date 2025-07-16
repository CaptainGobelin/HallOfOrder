tool
extends Node2D

export(String) var title = "BIOME_0" setget setTitle
export(int) var level = 1 setget setLevel

func _ready():
	Signals.connect("language_changed", self, "drawTitle")
	drawTitle()

func colorize():
	var color = Utils.getBiomeColor()
	$LeftLeaves.modulate = color
	$RightLeaves.modulate = color

func setTitle(value: String):
	title = value
	drawTitle()

func setLevel(value: int):
	level = value
	drawTitle()

func drawTitle():
	if not has_node("Label"):
		return
	$Label.text = tr(title) + " - " + Utils.toRoman(level)

func _on_Label_resized():
	$LeftLeaves.position.x = -$Label.rect_size.x/2 - 4.5
	$RightLeaves.position.x = $Label.rect_size.x/2 + 4.5
