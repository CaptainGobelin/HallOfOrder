extends Node

var skipGamemode: bool = false

const PRO_CHOOSE = 0
const PRO_CREATE = 1
var profileMode: int = PRO_CHOOSE

var lastProfile: String = ""
var saveFilename: String = ""
var username: String = "Default"
var currentLevel: Vector2 = Vector2(0, 0)

const BI_UNLOCK = 0
var biomes: Dictionary = {}

const LVL_UNLOCK = 0
const LVL_DONE = 1
var levels: Dictionary = {}

var progress: int = 0

func _ready():
	loadSettings()
	pass

func createProfile(name: String) -> bool:
	username = name
	currentLevel = Vector2(0, 0)
	biomes = {}
	levels = {}
	progress = 0
	saveFilename = Utils.strToFilename(name)
	lastProfile = saveFilename
	if not saveSettings():
		return false
	return save()

# Give progress in percent
func getProgress(p: int = -1) -> int:
	if p == -1:
		p = progress
	var percent = float(p) / float(Data.LEVEL_NB * Data.FLOOR_NB)
	return int(floor(percent * 100))

const SAVE_PATH = "user://"
const GENERAL_PATH = "user://settings.sav"

func saveSettings() -> bool:
	var file = File.new()
	file.open(GENERAL_PATH, File.WRITE)
	var settings = {
		"lastProfile": lastProfile
	}
	file.store_var(settings, true)
	file.close()
	return true

func loadSettings() -> bool:
	var file = File.new()
	if not file.file_exists(GENERAL_PATH):
		return false
	file.open(GENERAL_PATH, File.READ)
	var settings = file.get_var(true)
	lastProfile = settings["lastProfile"]
	file.close()
	return true

func getLastUsername() -> String:
	if lastProfile == "":
		return ""
	var data = loadSimple(lastProfile)
	if data.empty():
		return ""
	return data[0]

func save() -> bool:
	var file = File.new()
	file.open(SAVE_PATH + saveFilename + ".sav", File.WRITE)
	var data = {
		"username": username,
		"currentLevel": [currentLevel.x, currentLevel.y],
		"progress": progress
	}
	file.store_var(data, true)
	file.store_var(biomes, true)
	file.store_var(levels, true)
	file.close()
	return true

func load(filename: String):
	var file = File.new()
	if not file.file_exists(SAVE_PATH + filename + ".sav"):
		return false
	file.open(SAVE_PATH + filename + ".sav", File.READ)
	loadData(file.get_var(true))
	biomes = file.get_var(true)
	levels = file.get_var(true)
	file.close()
	saveFilename = filename
	lastProfile = saveFilename
	return true

func delete(filename: String):
	var file = File.new()
	if not file.file_exists(SAVE_PATH + filename + ".sav"):
		return false
	var dir = Directory.new()
	return dir.remove(SAVE_PATH + filename + ".sav") == OK

func getAllProfiles() -> Array:
	print(OS.get_user_data_dir())
	var result = []
	var dir = Directory.new()
	if dir.open(SAVE_PATH) != OK:
		return result
	dir.list_dir_begin()
	var filename = "start"
	while filename != "":
		filename = dir.get_next()
		if filename == "settings.sav":
			continue
		if filename.get_extension() != "sav":
			continue
		var data = loadSimple(filename.trim_suffix(".sav"))
		if data.empty():
			continue
		result.append(data)
	return result

func loadSimple(filename: String) -> Array:
	var result = {}
	var file = File.new()
	if not file.file_exists(SAVE_PATH + filename + ".sav"):
		return []
	file.open(SAVE_PATH + filename + ".sav", File.READ)
	result = file.get_var(true)
	file.close()
	return [result["username"], getProgress(result["progress"]), filename]

func loadData(dict: Dictionary):
	username = dict["username"]
	currentLevel.x = dict["currentLevel"][0]
	currentLevel.y = dict["currentLevel"][1]
	progress = dict["progress"]

func isUnlockedWorld(world: int) -> bool:
	if not biomes.has(world):
		return false
	return biomes[world][BI_UNLOCK]

func isUnlockedLevel(world: int, level: int) -> bool:
	if not levels.has(String(world) + "_" + String(level)):
		return false
	return levels[String(world) + "_" + String(level)][LVL_UNLOCK]

func isDoneLevel(world: int, level: int) -> bool:
	if not levels.has(String(world) + "_" + String(level)):
		return false
	return levels[String(world) + "_" + String(level)][LVL_DONE]
