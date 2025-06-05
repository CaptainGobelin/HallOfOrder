extends Node

var isIngame: bool = false
var skipGamemode: bool = false
var firstLaunch: bool = true

var introPlayed: Array = []

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

#Settings
var brightness: float = 1.0
var fullscreen: bool = false
var screenSize: Vector2 = Vector2(960, 720)
const LANG_ENGLISH = 0
const LANG_FRENCH = 1
var language: int = LANG_ENGLISH
const CURSOR_S = 0
const CURSOR_M = 1
const CURSOR_L = 2
var cursorSize = CURSOR_M
const ANIM_NORMAL = 0
const ANIM_FAST = 1
var animSpeed: int = ANIM_NORMAL
var dragHero: bool = false
var musicVolume: int = 8
var soundsVolume: int = 8
var muted: bool = false

func _ready():
	loadSettings()
	loadProfile(lastProfile)
	Signals.allSettings()

func createProfile(name: String) -> bool:
	username = name
	currentLevel = Vector2(0, 0)
	biomes = { 0: [true] }
	levels = { "0_0": [true, false]}
	progress = 0
	animSpeed = ANIM_NORMAL
	cursorSize = CURSOR_M
	dragHero = false
	saveFilename = Utils.strToFilename(name)
	return saveProfile()

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
		"lastProfile": lastProfile,
		"brightness": brightness,
		"fullscreen": fullscreen,
		"screenSize": vecToJson(screenSize),
		"musicVolume": musicVolume,
		"soundsVolume": soundsVolume,
		"muted": muted,
		"language": language,
	}
	file.store_var(settings, true)
	file.close()
	return saveProfile()

func loadSettings() -> bool:
	var file = File.new()
	if not file.file_exists(GENERAL_PATH):
		return false
	file.open(GENERAL_PATH, File.READ)
	var settings = file.get_var(true)
	lastProfile = settings["lastProfile"]
	brightness = settings["brightness"]
	fullscreen = settings["fullscreen"]
	screenSize = jsonToVec(settings["screenSize"])
	musicVolume = settings["musicVolume"]
	soundsVolume = settings["soundsVolume"]
	muted = settings["muted"]
	language = settings["language"]
	file.close()
	introPlayed = []
	return true

func getLastUsername() -> String:
	if lastProfile == "":
		return ""
	var data = loadSimple(lastProfile)
	if data.empty():
		return ""
	return data[0]

func saveProfile() -> bool:
	if saveFilename == "":
		return true
	var file = File.new()
	file.open(SAVE_PATH + saveFilename + ".sav", File.WRITE)
	var data = {
		"username": username,
		"currentLevel": [currentLevel.x, currentLevel.y],
		"progress": progress,
		"animSpeed": animSpeed,
		"cursorSize": cursorSize,
		"dragHero": dragHero
	}
	file.store_var(data, true)
	file.store_var(biomes, true)
	file.store_var(levels, true)
	file.close()
	return true

func loadProfile(filename: String):
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
	saveSettings()
	return true

func delete(filename: String):
	var file = File.new()
	if not file.file_exists(SAVE_PATH + filename + ".sav"):
		return false
	var dir = Directory.new()
	return dir.remove(SAVE_PATH + filename + ".sav") == OK

func getAllProfiles() -> Array:
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
	animSpeed = dict["animSpeed"]
	cursorSize = dict["cursorSize"]
	dragHero = dict["dragHero"]

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

func completeLevel(world: int, level: int):
	if not isDoneLevel(world, level):
		progress += 1
	levels[String(world) + "_" + String(level)] = [true, true]
	if world == 0 and level <= 7:
		if not levels.has(String(world) + "_" + String(level + 1)):
			levels[String(world) + "_" + String(level + 1)] = [true, false]
		else:
			levels[String(world) + "_" + String(level + 1)][LVL_UNLOCK] = true
	else:
		for i in range(1, 4):
			var l = level + i
			var w = world
			if l >= Data.FLOOR_NB:
				w += 1
				biomes[w] = [true]
				l -= Data.FLOOR_NB
			if not levels.has(String(w) + "_" + String(l)):
				levels[String(w) + "_" + String(l)] = [true, false]
			else:
				levels[String(w) + "_" + String(l)][LVL_UNLOCK] = true
	saveProfile()

func vecToJson(v: Vector2) -> Array:
	return [v.x, v.y]

func jsonToVec(array: Array) -> Vector2:
	return Vector2(array[0], array[1])
