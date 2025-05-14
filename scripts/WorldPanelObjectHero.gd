tool
extends Node2D

export(Data.classes) var type = Data.classes.Wizard setget setType
var isDisabled: bool = false

func _ready():
	setType(type)

func disable():
	isDisabled = true
	$Body.frame = type + 9

func setType(value: int):
	type = value
	if has_node("Body"):
		$Body.frame = type + 9
		$Body/Color.frame = type + 18

func hover():
	$Body.frame = type

func unhover():
	$Body.frame = type + 9

func setColor(world: int):
	$Body.self_modulate = Data.BIOMES[world][Data.BI_COLOR]
