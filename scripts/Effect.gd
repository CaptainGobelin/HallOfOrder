extends Node2D
class_name Effect
signal completed

onready var sprite = $Sprite
onready var animator = $AnimationPlayer

export (Data.effects) var type = Data.effects.Slash setget setType
export var coords = 0 setget setCoord

var pos: Vector2
var dir = null
var fatal: bool = false

func setType(value):
	type = value
	setCoord(coords)

func setCoord(value):
	coords = value
	if not has_node("Sprite"):
		return
	$Sprite.frame_coords = Vector2(value, type)

func _ready():
	animator.playback_speed = Data.ANIM_SPEED
	sprite.visible = false

static func killAll():
	for e in Ref.game.effects.get_children():
		Ref.game.effects.remove_child(e)
		e.queue_free()

static func isFatal(effects: Array) -> bool:
	for e in effects:
		if e.fatal:
			return true
	return false

static func launchAt(effectType: int, direction: int, cell: Vector2, addToWaiter: bool = false) -> Array:
	var effect = Utils.instanciate(Ref.game.effectScene, Ref.game.effects) as Effect
	if addToWaiter:
		Waiter.add(effect.launch(effectType, direction, cell))
	else:
		effect.launch(effectType, direction, cell)
	return [effect]

static func launchOnLine(effectType: int, direction: int, cell: Vector2, addToWaiter: bool = false) -> Array:
	var result = []
	var effectPos = cell + Data.DIRECTIONS[direction]
	while not Ref.board.isBlocked(effectPos):
		var effect = Utils.instanciate(Ref.game.effectScene, Ref.game.effects) as Effect
		if addToWaiter:
			Waiter.add(effect.launch(effectType, direction, effectPos))
		else:
			effect.launch(effectType, direction, effectPos)
		result.append(effect)
		effectPos = effectPos + Data.DIRECTIONS[direction]
	return result

static func launchAround(effectType: int, cell: Vector2, addToWaiter: bool = false) -> Array:
	var result = []
	for i in range(0, 4):
		var effectPos = cell + Data.DIRECTIONS[i]
		if effectPos.x < 0 or effectPos.y < 0:
			continue
		if effectPos.x >= Data.BOARD_X or effectPos.y >= Data.BOARD_Y:
			continue
		var effect = Utils.instanciate(Ref.game.effectScene, Ref.game.effects) as Effect
		if addToWaiter:
			Waiter.add(effect.launch(effectType, i, effectPos))
		else:
			effect.launch(effectType, i, effectPos)
		result.append(effect)
	return result

static func launchAroundWithDiag(effectType: int, cell: Vector2, addToWaiter: bool = false) -> Array:
	var result = launchAround(effectType, cell, addToWaiter)
	for i in range(0, 4):
		var effectPos = cell + Data.DIAGONALS[i]
		if effectPos.x < 0 or effectPos.y < 0:
			continue
		if effectPos.x >= Data.BOARD_X or effectPos.y >= Data.BOARD_Y:
			continue
		var effect = Utils.instanciate(Ref.game.effectScene, Ref.game.effects) as Effect
		if addToWaiter:
			Waiter.add(effect.launch(effectType, i, effectPos))
		else:
			effect.launch(effectType, i, effectPos)
		result.append(effect)
	return result

func launch(effectType: int, direction: int, cell: Vector2):
	pos = cell
	dir = Data.DIRECTIONS[direction]
	position = cell * Data.CELL_SIZE
	setType(effectType)
	sprite.visible = true
	if shouldFaceDirection():
		match direction:
			Data.DIR_LEFT: 
				sprite.flip_h = true
			Data.DIR_UP: 
				sprite.rotation_degrees = -90
				sprite.position.y = 9
			Data.DIR_DOWN:
				sprite.rotation_degrees = 90
				sprite.position.x = 9
	animator.play("Play")
	apply()
	yield(animator, "animation_finished")
	emit_signal("completed")
	if not Engine.is_editor_hint():
		get_parent().remove_child(self)
		queue_free()

func shouldFaceDirection() -> bool:
	if type == 2: return true
	return false

func apply():
	var target = Ref.board.getCellEntity(pos)
	if target == null:
		return
	match type:
		Data.effects.Slash:
			fatal = applySlash(target)
		Data.effects.Fire:
			fatal = applyFire(target)
		Data.effects.Push:
			fatal = applyPush(target)

func applyFire(target) -> bool:
	if target.is_in_group("Hero"):
		if target.type == Data.classes.Paladin:
			return false
	elif target.is_in_group("Monster"):
		if target.type == Data.monsters.Slime:
			target.setType(Data.monsters.SlimeHurt)
			target.get_node("AnimationPlayer").play("Crumble")
			return false
	return target.die()

func applySlash(target) -> bool:
	if target.is_in_group("Hero"):
		if target.type == Data.classes.Paladin:
			return false
	elif target.is_in_group("Monster"):
		if target.type == Data.monsters.Slime:
			target.setType(Data.monsters.SlimeHurt)
			target.get_node("AnimationPlayer").play("Crumble")
			return false
		if target.type == Data.monsters.Bat:
			if target.move(Data.DIRECTIONS[Data.dirs.Right]):
				return false
	elif target.is_in_group("Scenery"):
		if target.type == Data.sceneries.LeverOff:
			target.trigger(true)
		elif target.type == Data.sceneries.LeverOn:
			target.trigger(true)
	return target.die()

func applyPush(target) -> bool:
	return target.push(dir)
