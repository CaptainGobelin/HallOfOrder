tool
extends Node2D
class_name Monster

export (Data.monsters) var type = Data.monsters.Goblin setget setType

var pos: Vector2 = Vector2(0, 0)
var initPos: Vector2 = Vector2(0, 0)
var isDead = false
var isDying = false
var isFake: bool = false

static func addMonster(monsterType: int, cell: Vector2):
	var monster = Utils.instanciate(Ref.game.monsterScene, Ref.monsters)
	monster.setType(monsterType)
	monster.colorize()
	monster.placeOnBoard(cell)

static func getFakeMonster(monsterType: int) -> Monster:
	var monster = Utils.createFake(Ref.game.monsterScene)
	monster.setType(monsterType)
	monster.isFake = true
	return monster

func _ready():
	ButtonHandler.register(self, ButtonHandler.Types.Entity)
	$Body.set_material($Body.get_material().duplicate())
	$Body.material.set_shader_param("outLineColor", Colors.transparent)

func setType(value: int):
	type = value
	if not has_node("Body"):
		return
	$Body.frame = value

func colorize():
	var color = Utils.getBiomeColor()
	$Body.self_modulate = color

func placeOnBoard(cell: Vector2):
	$Body.visible = true
#	$TextureButton.disabled = false
	initPos = cell
	setPos(cell)

func setPos(cell: Vector2):
	pos = cell
	var boardPos = (cell + Vector2(1, 1)) * Ref.board.scale.x
	global_position = Ref.board.position + (boardPos * Data.CELL_SIZE)

func disable():
	$TextureButton.disabled = true

func enable():
	$TextureButton.disabled = false

static func playAll(monsterType: int):
	for m in Ref.monsters.get_children():
		if m.isDead:
			continue
		if m.type == monsterType:
			m.play()

func play():
	match type:
		Data.monsters.Skeleton:
			if not $AnimationPlayer.current_animation == "Death":
				$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Slash, pos, true)

func die():
	if isDead or isDying:
		return
	isDying = true
	$AnimationPlayer.play("Death")

func push(dir: Vector2) -> bool:
	var result = false
	var newPos = pos + dir
	if Board.isBlocked(newPos):
		die()
		return true
	var entity = Board.getCellEntity(newPos)
	if entity != null:
		result = result or entity.push(dir)
		if entity.is_in_group("Scenery"):
			result = result or entity.activate(self)
	setPos(pos + dir)
	$AnimationPlayer.play("Crumble")
	return result

func reset():
	if type == Data.monsters.SlimeHurt:
		setType(Data.monsters.Slime)
	isDead = false
	isDying = false
	setPos(initPos)
	$AnimationPlayer.play("RESET")

func restart():
	reset()

func outline(value: bool = true):
	if isFake:
		for m in Ref.monsters.get_children():
			if m.type == type:
				m.outline(value)
		return
	if value:
		$Body.material.set_shader_param("outLineColor", Colors.red)
	else:
		$Body.material.set_shader_param("outLineColor", Colors.transparent)

func _on_TextureButton_mouse_entered():
	match type:
		Data.monsters.Goblin:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Goblin)
		Data.monsters.Skeleton:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Skeleton)
		Data.monsters.Slime:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Slime)
	var slot = Ref.turnOrder.getTurnOrderObjectByEntity(self)
	if slot != null:
		slot.outline()

func _on_TextureButton_mouse_exited():
	Ref.ui.hideTooltip()
	var slot = Ref.turnOrder.getTurnOrderObjectByEntity(self)
	if slot != null:
		slot.outline(false)
