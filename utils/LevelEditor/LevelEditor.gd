extends Node2D

onready var entityScene = preload("res://utils/LevelEditor/EntityButton.tscn")

var selected = -1

func _ready():
	for c in $Buttons.get_children():
		c.get_node("Button").connect("pressed", self, "selectEntity", [c])
	$LevelOptions.clear()
	for i in range(Data.LEVEL_NB):
		$LevelOptions.add_item(Utils.toRoman(i+1))
	$FloorOptions.clear()
	for i in range(Data.FLOOR_NB):
		$FloorOptions.add_item(Utils.toRoman(i+1))

func loadLevel(world: int, level: int):
	if not LevelLoader.levels.has(String(world) + "_" + String(level)):
		$NoDataDialog.popup()
		return
	flush()
	var lvl = LevelLoader.levels[String(world) + "_" + String(level)]
	for _i in range(lvl[LevelLoader.TURN_ORDER][LevelLoader.SIZE]):
		$TurnOrder.addSlot()
	for s in lvl[LevelLoader.TURN_ORDER][LevelLoader.SLOTS]:
		$TurnOrder.get_node("Turns").get_child(s[LevelLoader.ORDER]).setContained(s[LevelLoader.TYPE])
	for h in lvl[LevelLoader.HEROES]:
		$HeroPool.addHero(h[LevelLoader.TYPE])
	for m in lvl[LevelLoader.MONSTERS]:
		placeEntity(m[LevelLoader.POSITION], m[LevelLoader.TYPE], 1)
	for s in lvl[LevelLoader.SCENERIES]:
		placeEntity(s[LevelLoader.POSITION], s[LevelLoader.TYPE], 2)

func selectEntity(entity: Node):
	if entity.isHero:
		$HeroPool.addHero(entity.type)
	else:
		selected = entity.type + 100 * entity.category
		$CurrentSelection/EntityButton.setType(selected)

func setTurn(turn: Node):
	if turn.contained == -1 and $CurrentSelection/EntityButton.isMonster:
		turn.setContained($CurrentSelection/EntityButton.type)
	else:
		turn.setContained(-1)

func flush():
	$HeroPool.flush()
	$TurnOrder.flush()
	for e in $Entities.get_children():
		e.delete()

func saveLevel():
	var world = String($LevelOptions.selected)
	var level = String($FloorOptions.selected)
	var heroes = []
	var monsters = []
	var sceneries = []
	for h in $HeroPool.get_children():
		var entry = {}
		entry[LevelLoader.TYPE] = h.type
		entry[LevelLoader.POOL_POS] = h.poolPos
		heroes.append(entry)
	for e in $Entities.get_children():
		var entry = {}
		entry[LevelLoader.TYPE] = e.type
		entry[LevelLoader.POSITION] = e.pos
		if e.isMonster:
			monsters.append(entry)
		elif e.isScenery:
			sceneries.append(entry)
	var turnOrder = {}
	turnOrder[LevelLoader.SIZE] = $TurnOrder.getSize()
	turnOrder[LevelLoader.SLOTS] = $TurnOrder.getSlots()
	var levelDict = {}
	levelDict[LevelLoader.HEROES] = heroes
	levelDict[LevelLoader.MONSTERS] = monsters
	levelDict[LevelLoader.SCENERIES] = sceneries
	levelDict[LevelLoader.TURN_ORDER] = turnOrder
	LevelLoader.levels[String(world) + "_" + String(level)] = levelDict
	LevelLoader.saveLevels()

func _on_TextureButton_pressed(forceNoStack: bool = false):
	if selected == -1:
		return
	var pos = $Board.get_local_mouse_position() / 9
	pos.x = floor(pos.x - 1)
	pos.y = floor(pos.y - 1)
	placeEntity(pos, -1, 0, forceNoStack)

func placeEntity(pos: Vector2, type: int = -1, category: int = 0, forceNoStack: bool = false):
	if type == -1:
		type = selected
	else:
		type = type + 100 * category
	var entity = Utils.instanciate(entityScene, $Entities)
	entity.setType(type)
	entity.pos = pos
	entity.position = pos * 9
	entity.boardMode()
	entity.forceNoStack = forceNoStack

func _on_ExportButton_pressed():
	$ExportConfirm.popup()

func _on_ExportConfirm_confirmed():
	saveLevel()

func _on_ImportButton_pressed():
	$ImportConfirm.popup()

func _on_ImportConfirm_confirmed():
	loadLevel($LevelOptions.selected, $FloorOptions.selected)

func _on_NewButton_pressed():
	$NewConfirm.popup()

func _on_NewConfirm_confirmed():
	flush()
