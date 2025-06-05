extends Node2D

signal pressed

var world: int

func _ready():
	for w in $Rotator/Levels.get_children():
		w.connect("pressed", self, "pressed")

func setWorld(value: int):
	world = value
	var count = 0
	for w in $Rotator/Levels.get_children():
		w.init(world, count)
		count += 1
	setColor()

func pressed(w: Node2D):
	emit_signal("pressed", w)

func setColor():
	$Rotator/TileMap.modulate = Data.BIOMES[world][Data.BI_COLOR]
