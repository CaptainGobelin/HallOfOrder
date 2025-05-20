tool
extends Node2D

export var length = 92 setget setLength
export var elements = 6

onready var up = get_node("Up")
onready var down = get_node("Down")
onready var elevator = get_node("Elevator")

var isActive: bool = false

func setLength(value):
	length = value
	if not has_node("Elevator"):
		return
	get_node("Down").position.y = length - 1
	get_node("Elevator").margin_bottom = length

func setArrows(startIndex: int, maxIndex: int):
	if startIndex + elements < maxIndex:
		down.frame = 28
	else:
		down.frame = 34
	if startIndex > 0:
		up.frame = 27
	else:
		up.frame = 33
	if down.frame == 34 and up.frame == 33:
		elevator.color = Colors.shade5
		isActive = false
	else:
		elevator.color = Colors.shade3
		elevator.margin_top = length * (float(startIndex)/float(maxIndex))
		elevator.margin_bottom = length * (float(startIndex+elements)/float(maxIndex))
		isActive = true
