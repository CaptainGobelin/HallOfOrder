tool
extends Node2D
class_name Scenery

export (Data.sceneries) var type = Data.sceneries.Pillar setget setType

var originalType: int = 0
var pos: Vector2 = Vector2(0, 0)
var initPos: Vector2 = Vector2(0, 0)

static func addScenery(sceneryType: int, cell: Vector2):
	var scenery = Utils.instanciate(Ref.game.sceneryScene, Ref.sceneries)
	scenery.setType(sceneryType)
	scenery.colorize()
	scenery.placeOnBoard(cell)

func _ready():
	setType(type)

func setType(value: int, isOriginal: bool = true):
	type = value
	if isOriginal:
		originalType = value
	if not has_node("Sprite"):
		return
	$Sprite.frame  = value

func colorize():
	var color = Utils.getBiomeColor()
	$Sprite.self_modulate = color
	$Effect.self_modulate = color

func placeOnBoard(cell: Vector2):
	$Sprite.visible = true
	initPos = cell
	setPos(cell)

func setPos(cell: Vector2):
	pos = cell
	var boardPos = (cell + Vector2(1, 1)) * Ref.board.scale.x
	global_position = Ref.board.position + (boardPos * Data.CELL_SIZE)

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
		_:
			return false

func trigger(recursive: bool):
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

func push(_dir: Vector2) -> bool:
	return false

func die() -> bool:
	return false

func reset():
	setType(originalType)
	$AnimationPlayer.play("RESET")

func _on_TextureButton_mouse_entered():
	match type:
		Data.sceneries.Spikes:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Spikes)

func _on_TextureButton_mouse_exited():
	Ref.ui.hideTooltip()
