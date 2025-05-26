tool
extends Node2D
class_name Scenery

export (Data.sceneries) var type = Data.sceneries.Pillar setget setType

var pos: Vector2 = Vector2(0, 0)
var initPos: Vector2 = Vector2(0, 0)

static func addScenery(sceneryType: int, cell: Vector2):
	var scenery = Utils.instanciate(Ref.game.sceneryScene, Ref.sceneries)
	scenery.setType(sceneryType)
	scenery.colorize()
	scenery.placeOnBoard(cell)

func _ready():
	setType(type)

func setType(value: int):
	type = value
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
			entity.die()
			$AnimationPlayer.play("Spikes")
			return true
	return false

func isBlocking() -> bool:
	match type:
		Data.sceneries.Pillar:
			return true
		_:
			return false

func push(_dir: Vector2) -> bool:
	return false

func die():
	return

func _on_TextureButton_mouse_entered():
	match type:
		Data.sceneries.Spikes:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Spikes)

func _on_TextureButton_mouse_exited():
	Ref.ui.hideTooltip()
