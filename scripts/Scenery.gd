tool
extends Node2D
class_name Scenery

export (Data.sceneries) var type = Data.sceneries.Pillar setget setType

var originalType: int = 0
var pos: Vector2 = Vector2(0, 0)
var initPos: Vector2 = Vector2(0, 0)
var pair = null
var isMain: bool = false

static func addScenery(sceneryType: int, cell: Vector2):
	var scenery = Utils.instanciate(Ref.game.sceneryScene, Ref.sceneries)
	scenery.setType(sceneryType)
	scenery.colorize()
	scenery.placeOnBoard(cell)

func _ready():
	setType(type)
	$Sprite.set_material($Sprite.get_material().duplicate())

func setType(value: int, isOriginal: bool = true):
	type = value
	if isOriginal:
		originalType = value
	if not has_node("Sprite"):
		return
	if $TextureButton/TextureButton2.is_connected("pressed", Ref.board, "_on_TextureButton_pressed"):
		$TextureButton/TextureButton2.disconnect("pressed", Ref.board, "_on_TextureButton_pressed")
	if isIgnored():
		$TextureButton/TextureButton2.visible = true
		$TextureButton/TextureButton2.connect("pressed", Ref.board, "_on_TextureButton_pressed")
	$Sprite.frame  = value
	match type:
		Data.sceneries.TeleportA:
			$Sprite.material.set_shader_param("outLineColor", Colors.purple)
		Data.sceneries.TeleportB:
			$Sprite.material.set_shader_param("outLineColor", Colors.cyan)

func colorize():
	var color = Utils.getBiomeColor()
	$Sprite.self_modulate = color
	$Effect.self_modulate = color

func placeOnBoard(cell: Vector2):
	$Sprite.visible = true
	initPos = cell
	setPos(cell)
	match type:
		Data.sceneries.TeleportA, Data.sceneries.TeleportB:
			getPair()

func setPos(cell: Vector2):
	pos = cell
	var boardPos = (cell + Vector2(1, 1)) * Ref.board.scale.x
	global_position = Ref.board.position + (boardPos * Data.CELL_SIZE)

func getPair():
	if pair != null:
		return pair
	for s in Ref.sceneries.get_children():
		if s.type == type:
			if s.get_instance_id() != get_instance_id():
				pair = s
				isMain = true
				pair.pair = self
				return s
	return null

func activate(entity: Node) -> bool:
	match type:
		Data.sceneries.Spikes:
			$AnimationPlayer.play("Spikes")
			return entity.die()
	return false

func isBlocking() -> bool:
	match type:
		Data.sceneries.Pillar:
			return true
		Data.sceneries.PillarOn:
			return true
		Data.sceneries.LeverOff:
			return true
		Data.sceneries.LeverOn:
			return true
		_:
			return false

func isIgnored() -> bool:
	match type:
		Data.sceneries.PillarOff:
			return true
		Data.sceneries.Exploded:
			return true
		Data.sceneries.TeleportA:
			return true
		Data.sceneries.TeleportB:
			return true
	return false

func trigger(recursive: bool) -> bool:
	match type:
		Data.sceneries.PillarOff:
			var target = Ref.board.getCellEntity(pos)
			if target != null:
				target.die()
			setType(Data.sceneries.PillarOn, false)
			$AnimationPlayer.play("PillarUp")
		Data.sceneries.PillarOn:
			setType(Data.sceneries.PillarOff, false)
			$AnimationPlayer.play("PillarUp")
		Data.sceneries.LeverOff:
			if recursive:
				for s in Ref.sceneries.get_children():
					s.trigger(false)
			else:
				setType(Data.sceneries.LeverOn, false)
		Data.sceneries.LeverOn:
			if recursive:
				for s in Ref.sceneries.get_children():
					s.trigger(false)
			else:
				setType(Data.sceneries.LeverOff, false)
		Data.sceneries.TeleportA, Data.sceneries.TeleportB:
			if isMain:
				var entity1 = Board.getCellEntity(pos)
				var entity2 = Board.getCellEntity(pair.pos)
				if entity1 != null or entity2 != null:
					Effect.launchAt(Data.effects.Teleport, Data.DIR_RIGHT, pos, true)
					Effect.launchAt(Data.effects.Teleport, Data.DIR_RIGHT, pair.pos, true)
				if entity1 != null:
					entity1.setPos(pair.pos)
				if entity2 != null:
					entity2.setPos(pos)
	return false

func push(dir: Vector2) -> bool:
	match type:
		Data.sceneries.LeverOff:
			trigger(true)
		Data.sceneries.LeverOn:
			trigger(true)
		Data.sceneries.Barrel:
			return realPush(dir)
	return false

func realPush(dir: Vector2) -> bool:
	var result = false
	var newPos = pos + dir
	if Board.isBlocked(newPos):
		return die()
	var entity = Board.getCellEntity(newPos)
	if entity != null:
		result = result or entity.push(dir)
		if entity.is_in_group("Scenery"):
			result = result or entity.activate(self)
	$AnimationPlayer.play("Crumble")
	setPos(pos + dir)
	return result

func die() -> bool:
	match type:
		Data.sceneries.Barrel:
			setType(Data.sceneries.Exploded, false)
			Effect.launchAt(Data.effects.Explode, Data.DIR_RIGHT, pos, true)
			return Effect.isFatal(Effect.launchAroundWithDiag(Data.effects.Fire, pos, true))
	return false

func reset():
	setType(originalType)
	setPos(initPos)
	$AnimationPlayer.play("RESET")

func _on_TextureButton_mouse_entered():
	match type:
		Data.sceneries.Spikes:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Spikes)
		Data.sceneries.PillarOff, Data.sceneries.PillarOn:
			Ref.ui.showTooltip((TooltipFactory.tooltips.SwitchBlock))
		Data.sceneries.LeverOff, Data.sceneries.LeverOn:
			Ref.ui.showTooltip((TooltipFactory.tooltips.Lever))
		Data.sceneries.TeleportA, Data.sceneries.TeleportB:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Teleporter)
		Data.sceneries.Barrel:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Barrel)
func _on_TextureButton_mouse_exited():
	Ref.ui.hideTooltip()

func _on_TextureButton2_mouse_entered():
	_on_TextureButton_mouse_entered()
	match type:
		Data.sceneries.TeleportA:
			$Sprite.material.set_shader_param("disabled", false)
			pair.get_node("Sprite").material.set_shader_param("disabled", false)
		Data.sceneries.TeleportB:
			$Sprite.material.set_shader_param("disabled", false)
			pair.get_node("Sprite").material.set_shader_param("disabled", false)

func _on_TextureButton2_mouse_exited():
	_on_TextureButton_mouse_exited()
	match type:
		Data.sceneries.TeleportA, Data.sceneries.TeleportB:
			$Sprite.material.set_shader_param("disabled", true)
			pair.get_node("Sprite").material.set_shader_param("disabled", true)
