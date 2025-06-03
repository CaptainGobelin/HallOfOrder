extends Node

const filePath = "res://data/level_data.gd"
const backupPath = "res://data/levels_"
const dataPrefix = "extends Node\n\nconst DATA: Dictionary = "

const TURN_ORDER = "TurnOrder"
const HEROES = "Heroes"
const MONSTERS = "Monsters"
const SCENERIES = "Sceneries"
const TYPE = "Type"
const POSITION = "Position"
const POOL_POS = "Pool position"
const SIZE = "Size"
const SLOTS = "Slots"
const ORDER = "Order"

var levels: Dictionary = {}

func _ready():
	loadLevels()

func createBackup():
	var file = File.new()
	if not file.file_exists(filePath):
		return
	file.open(filePath, File.READ)
	var fileContent = file.get_as_text()
	file.close()
	var backup = File.new()
	var dateTime = Time.get_datetime_string_from_system().replace(":", "_")
	var backupFilename = backupPath + dateTime + ".txt"
	backup.open(backupFilename, File.WRITE_READ)
	backup.store_string(fileContent)
	backup.close()

func loadLevels():
	levels.clear()
	levels = LevelData.DATA.duplicate(true)

func saveLevels():
	var lvlString = Utils.dict_to_string(levels)
	createBackup()
	var file = File.new()
	file.open(filePath, File.WRITE_READ)
	file.store_string(dataPrefix + lvlString)
	file.close()

func flushCurrentLevel():
	Effect.killAll()
	Waiter.flush()
	ButtonHandler.flush()
	for h in Ref.heroes.get_children():
		Ref.heroes.remove_child(h)
		h.queue_free()
	for m in Ref.monsters.get_children():
		Ref.monsters.remove_child(m)
		m.queue_free()
	for s in Ref.sceneries.get_children():
		Ref.sceneries.remove_child(s)
		s.queue_free()

func loadLevel(world: int, level: int):
	while level >= Data.FLOOR_NB:
		#TODO remove when not in demo
		Utils.changeScene("res://scenes/EndScreen.tscn")
		return
#		level -= Data.FLOOR_NB
#		world = (world + 1) % Data.LEVEL_NB
	var lvlName = String(world) + "_" + String(level)
	if not levels.has(lvlName):
		return loadLevel(world, level + 1)
	flushCurrentLevel()
	ProfileData.currentLevel = Vector2(world, level)
	var lvl = levels[lvlName]
	Ref.turnOrder.init(lvl[TURN_ORDER][SIZE])
	for s in lvl[TURN_ORDER][SLOTS]:
		Ref.turnOrder.setMonsterTurn(s[TYPE], s[ORDER])
	for h in lvl[HEROES]:
		Hero.addHero(h[TYPE])
	for m in lvl[MONSTERS]:
		Monster.addMonster(m[TYPE], m[POSITION])
	for s in lvl[SCENERIES]:
		Scenery.addScenery(s[TYPE], s[POSITION])
	Ref.ui.get_node("Title").setTitle(Data.BIOMES[world][Data.BI_NAME])
	Ref.ui.get_node("Title").setLevel(level + 1)
	Ref.ui.colorize()
	Ref.ui.hideTooltip()
	ScreenHandler.colorize()
	MouseHandler.normalMode()
	ButtonHandler.normalMode()
