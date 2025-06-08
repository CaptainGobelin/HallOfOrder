tool
extends Entity
class_name Hero

export (Data.classes) var type = Data.classes.Fighter setget setType
export (int) var poolPos = 0 setget placeOnPool

static func addHero(heroType: int):
	var hero = Utils.instanciate(Ref.game.heroScene, Ref.heroes)
	hero.setType(heroType)
	hero.colorize()
	hero.placeOnPool()

func _ready():
	poolPos = Ref.heroes.get_child_count() - 1
	placeOnPool()
	ButtonHandler.register(self, ButtonHandler.Types.Entity)
	$Body.set_material($Body.get_material().duplicate())
	$Body.material.set_shader_param("outLineColor", Colors.transparent)

func setType(value: int):
	type = value
	if not has_node("Body"):
		return
	$Body.frame  = value
	$Body/Colors.frame  = value + 9

func colorize():
	var color = Utils.getBiomeColor()
	$Body.self_modulate = color

func placeOnBoard(cell: Vector2):
	if not onBoard:
		Ref.turnOrder.fillFreeSpace(self)
	onBoard = true
	$Body.visible = true
	$TextureButton.visible = true
	initPos = cell
	setPos(cell)
	$AnimationPlayer.play("Pin")

func setPos(cell: Vector2):
	pos = cell
	var boardPos = (cell + Vector2(1, 1)) * Ref.board.scale.x
	global_position = Ref.board.position + (boardPos * Data.CELL_SIZE)

func placeOnPool(value: int = -1):
	if onBoard:
		Ref.turnOrder.freeSpace(self)
	onBoard = false
	if value >= 0:
		poolPos = value
	var p = Vector2(9, 9)
	p.x *= poolPos % 5
	p.y *= ceil(poolPos / 5)
	position = p

func cancelPick():
	$Body.visible = true
	$TextureButton.visible = true
	placeOnPool()
	$AnimationPlayer.play("Pin")

func _on_TextureButton_pressed():
	$Body.visible = false
	$TextureButton.visible = false
	MouseHandler.selectHeroMode(self)

func disable():
	$TextureButton.disabled = true
	$TextureButton/TextureButton2.disabled = true

func enable():
	$TextureButton.disabled = false
	$TextureButton/TextureButton2.disabled = false

func outline(value: bool = true):
	if value:
		$Body.material.set_shader_param("outLineColor", Colors.cyan)
	else:
		$Body.material.set_shader_param("outLineColor", Colors.transparent)

func push(dir: Vector2) -> bool:
	var result = false
	var newPos = pos + dir
	if Board.isBlocked(newPos):
		return die()
	var entity = Board.getCellEntity(newPos)
	if entity != null:
		result = result or entity.push(dir)
		if entity.is_in_group("Scenery"):
			result = result or entity.activate(self)
	setPos(newPos)
	if not result:
		$AnimationPlayer.play("Crumble")
	return result

func die() -> bool:
	if isDead:
		return false
	isDead = true
	if BattleHandler.currentThief != null:
		BattleHandler.currentThief.thiefKilled = self
	$AnimationPlayer.play("Death")
	return true

func reset():
	isDead = false
	barbarianToSlash = false
	barbarianShouldReplay = false
	thiefShouldReplay = false
	thiefKilled = null
	if onBoard:
		setPos(initPos)
	$AnimationPlayer.play("RESET")

func restart():
	placeOnPool(poolPos)

func _on_TextureButton_mouse_entered():
	match type:
		Data.classes.Fighter:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Fighter)
		Data.classes.Paladin:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Paladin)
		Data.classes.Monk:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Monk)
		Data.classes.Wizard:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Wizard)
		Data.classes.Barbarian:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Barbarian)
		Data.classes.Thief:
			Ref.ui.showTooltip(TooltipFactory.tooltips.Thief)
	if onBoard:
		Ref.turnOrder.getTurnOrderObjectByEntity(self).outline()

func _on_TextureButton_mouse_exited():
	Ref.ui.hideTooltip()
	if onBoard:
		Ref.turnOrder.getTurnOrderObjectByEntity(self).outline(false)

func _on_TextureButton2_pressed():
	placeOnPool(poolPos)
