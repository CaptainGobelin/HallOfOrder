extends Node2D
class_name TurnOrder

var size: int
var currentPosList: int = -1

func _ready():
	Ref.turnOrder = self
	set_process_input(false)

func getHeroSlot(hero: Node):
	for c in $Objects.get_children():
		if c.isActive and c.contained == hero:
			return c.posInList
	return null

func setMonsterTurn(type: int, space: int):
	fillSpace(Monster.getFakeMonster(type), space)

func fillFreeSpace(entity):
	for i in range(size):
		if getSpace(i).isEmpty:
			fillSpace(entity, i)
			return

func fillSpace(entity, i: int):
	var c = getSpace(i)
	c.contained = entity
	c.isEmpty = false
	if entity is Hero:
		c.get_node("Card/Hero").visible = true
		c.setHeroType(entity.type)
		c.get_node("Card/Monster").visible = false
		c.get_node("Card/Slot").visible = false
		c.isLocked = false
	elif entity is Monster:
		c.get_node("Card/Hero").visible = false
		c.get_node("Card/Monster").visible = true
		c.setMonsterType(entity.type)
		c.get_node("Card").z_index -= 1
		c.get_node("Card/Slot").visible = false
		c.isLocked = true
		c._on_TextureButton_mouse_exited()

func freeSpace(entity):
	for i in range(size):
		var c = getSpace(i)
		if c.contained == entity:
			c.freeSlot()
			return

func getSpace(i: int) -> TurnOrderObject:
	for c in $Objects.get_children():
		if c.posInList == i and c.isActive:
			return c
	return null

func getNextSpace(t: TurnOrderObject) -> TurnOrderObject:
	return getSpace(t.posInList + 1)

func isNextLocked(t: TurnOrderObject) -> bool:
	var next = getNextSpace(t)
	if next == null:
		return false
	return next.isLocked && next.isActive

func getPrevSpace(t: TurnOrderObject) -> TurnOrderObject:
	return getSpace(t.posInList - 1)

func isPrevLocked(t: TurnOrderObject) -> bool:
	var prev = getPrevSpace(t)
	if prev == null:
		return false
	return prev.isLocked && prev.isActive

func isSpaceLocked(p: int) -> bool:
	var space = getSpace(p)
	if space == null:
		return false
	return space.isLocked && space.isActive

func init(newSize: int):
	size = newSize
	for count in range($Objects.get_child_count()):
		var o = $Objects.get_child(count) as TurnOrderObject
		if count < size:
			o.init(size, count)
		else:
			o.unuse()
	$Objects.position.x = 136 - ((size-1) * 17)
	$TextureButton.margin_left = $Objects.position.x - 15
	$TextureButton.margin_right = $Objects.position.x + (size * 17.28 * scale.x) + 13

func _on_TextureButton_mouse_entered():
	if MouseHandler.currentMode == MouseHandler.SELECT_TURN_MODE:
#		$TextureButton.modulate = Color.red
		set_process_input(true)

func _on_TextureButton_mouse_exited():
#	$TextureButton.modulate = Color.black
	if MouseHandler.currentMode == MouseHandler.SELECT_TURN_MODE:
		for c in $Objects.get_children():
			if c.posInList != MouseHandler.selection.posInList:
				c.backToPos()
		currentPosList = MouseHandler.selection.posInList
	set_process_input(false)

func _input(event):
	if MouseHandler.currentMode != MouseHandler.SELECT_TURN_MODE:
		return
	if event is InputEventMouseMotion:
		var p = computeCurrentPos($Objects.get_local_mouse_position())
		if p == currentPosList:
			return
		if isSpaceLocked(p):
			for c in $Objects.get_children():
				c.backToPos()
		elif p == MouseHandler.selection.posInList:
			for c in $Objects.get_children():
				if c.posInList != MouseHandler.selection.posInList:
					c.backToPos()
		elif p < MouseHandler.selection.posInList:
			var toMove =  range(p, MouseHandler.selection.posInList)
			for c in $Objects.get_children():
				if c.isLocked:
					continue
				if toMove.has(c.posInList):
					if isNextLocked(c):
						c.moveRightTwo()
					else:
						c.moveRight()
				else:
					c.backToPos()
		elif p > MouseHandler.selection.posInList:
			var toMove = range(MouseHandler.selection.posInList+1, p+1)
			for c in $Objects.get_children():
				if c.isLocked:
					continue
				if toMove.has(c.posInList):
					if isPrevLocked(c):
						c.moveLeftTwo()
					else:
						c.moveLeft()
				else:
					c.backToPos()
		currentPosList = p

func computeCurrentPos(mousePos: Vector2) -> int:
	var result = mousePos.x / 17
	result = min(size-1, max(0, int(floor(result))))
	return result

func validatePick():
	if isSpaceLocked(currentPosList):
		return
	for c in $Objects.get_children():
		c.setPos(size, c.posInList + c.currentShift)
		c.animator.play("RESET")
	MouseHandler.selection.setPos(size, currentPosList)
	currentPosList = -1
