extends Node2D

export(bool) var isScenery = false setget setType
var isDisabled: bool = false

func _ready():
	setType(isScenery)

func disable():
	isDisabled = true
	if isScenery:
		$Body.frame = 3
	else:
		$Body.frame = 2

func setType(value: bool):
	isScenery = value
	if has_node("Body"):
		if isScenery:
			$Body.frame = 3
		else:
			$Body.frame = 2

func hover():
	if isScenery:
		$Body.frame = 1
	else:
		$Body.frame = 0

func unhover():
	if isScenery:
		$Body.frame = 3
	else:
		$Body.frame = 2

func setColor(world: int):
	$Body.self_modulate = Data.BIOMES[world][Data.BI_COLOR]
