tool
extends Node2D
class_name Hero

export (Data.classes) var type = Data.classes.Fighter setget setType
export (int) var poolPos = 0 setget placeOnPool

var onBoard: bool = false
var pos: Vector2 = Vector2(0, 0)
var initPos: Vector2 = Vector2(0, 0)
var isDead = false
var barbarianToSlash: bool = false
var shouldReplay: bool = false

static func addHero(heroType: int):
	var hero = Utils.instanciate(Ref.game.heroScene, Ref.heroes)
	hero.setType(heroType)
	hero.colorize()
	hero.placeOnPool()

func _ready():
	poolPos = Ref.heroes.get_child_count() - 1
	placeOnPool()
	ButtonHandler.register(self, ButtonHandler.Types.Entity)

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

func enable():
	$TextureButton.disabled = false

func play():
	if isDead:
		return
	if not onBoard:
		return
	match type:
		Data.classes.Fighter:
			$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Slash, pos, true)
		Data.classes.Paladin:
			$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Slash, pos, true)
		Data.classes.Monk:
			$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Push, pos, true)
		Data.classes.Barbarian:
			if barbarianToSlash:
				$AnimationPlayer.play("Crumble")
				var e = Effect.launchAt(Data.effects.Slash, Data.DIR_UP, pos + Data.DIRECTIONS[Data.DIR_UP], true)
				if shouldReplay or Effect.isFatal(e):
					BattleHandler.toPlay.insert(0, Ref.turnOrder.getHeroSlot(self))
				shouldReplay = false
				barbarianToSlash = false
			else:
				var e = Effect.launchAt(Data.effects.Push, Data.DIR_UP, pos, true)
				shouldReplay = Effect.isFatal(e)
				BattleHandler.toPlay.insert(0, Ref.turnOrder.getHeroSlot(self))
				barbarianToSlash = true
		Data.classes.Wizard:
			Effect.launchOnLine(Data.effects.Fire, Data.DIR_LEFT, pos, true)
			Effect.launchOnLine(Data.effects.Fire, Data.DIR_RIGHT, pos, true)

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
	setPos(newPos)
	return result

func die():
	if isDead:
		return
	isDead = true
	$AnimationPlayer.play("Death")

func reset():
	isDead = false
	barbarianToSlash = false
	shouldReplay = false
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

func _on_TextureButton_mouse_exited():
	Ref.ui.hideTooltip()
