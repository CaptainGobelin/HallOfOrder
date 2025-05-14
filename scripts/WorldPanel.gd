extends Node2D

var world: int

func setWorld(value: int):
	world = value
	var count = 0
	for w in $Rotator/Levels.get_children():
		w.init(world, count)
		count += 1
	setColor()

func setColor():
	$Rotator/TileMap.modulate = Data.BIOMES[world][Data.BI_COLOR]
