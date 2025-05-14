tool
extends Node2D

onready var turnScene = preload("res://utils/LevelEditor/Turn.tscn")

func addSlot():
	if $Turns.get_child_count() >= 9:
		return
	var turn = Utils.instanciate(turnScene, $Turns)
	turn.position.x = $Turns.get_child_count() * 45 + 10
	$Buttons/Label.text = String($Turns.get_child_count())
	if get_parent().is_in_group("LevelEditor"):
		turn.get_node("TextureButton").connect("pressed", get_parent(), "setTurn", [turn])

func removeSlot():
	if $Turns.get_child_count() == 0:
		return
	var last = $Turns.get_child($Turns.get_child_count() - 1)
	$Turns.remove_child(last)
	last.queue_free()
	$Buttons/Label.text = String($Turns.get_child_count())

func flush():
	for _i in range($Turns.get_child_count()):
		removeSlot()

func getSize() -> int:
	return $Turns.get_child_count()

func getSlots() -> Array:
	var result = []
	for i in $Turns.get_child_count():
		var t = $Turns.get_child(i)
		if t.contained == -1:
			continue
		var entry = {}
		entry[LevelLoader.TYPE] = t.contained
		entry[LevelLoader.ORDER] = i
		result.append(entry)
	return result

func _on_Plus_pressed():
	addSlot()

func _on_Minus_pressed():
	removeSlot()
