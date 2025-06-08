extends Node

enum classes {Wizard, Monk, Paladin, Barbarian, Fighter, Ranger, Thief, Cleric, Warlock}
enum monsters {Goblin, Skeleton, DarkWizard, Slime, SlimeHurt, Bat}
enum effects {Slash, Fire, Push}
enum sceneries {Pillar, Spikes}

const DIR_UP = 0
const DIR_RIGHT = 1
const DIR_DOWN = 2
const DIR_LEFT = 3

enum dirs {Up, Right, Down, Left}
const DIRECTIONS = [Vector2(0, -1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]

const CELL_SIZE = 9
const BOARD_X = 11
const BOARD_Y = 7

const COLOR_GREEN = Color(1.0, 1.0, 1.0)
const COLOR_ORANGE = Color(1.28, 1.0, 0.95)
const COLOR_BLUE = Color(1.07, 0.9, 1.25)
const COLOR_GREY = Color(1.05, 0.94, 1.21)

const ANIM_SPEED = 0.8

const FLOOR_NB = 15
const LEVEL_NB = 3

const BI_NAME = 0
const BI_COLOR = 1
const BIOMES = {
	0: ["Cavern", COLOR_GREEN],
	1: ["Volcano", COLOR_ORANGE],
	2: ["Abyss", COLOR_BLUE],
}

const TUTOS = {
	"0_0": "Place your fighter on the board then click PLAY to play the turn.",
	"0_1": "You need to kill every monster on the board to complete the level.",
	"0_2": "Some monsters, like the Skeleton, also play during the turn.\n\nYou can drag hero portraits in the TURN ORDER to modify the order in which your heroes will play.",
	"0_3": "Your heroes can also kill other heroes, but they don't all need to survive to complete the level.",
	"0_4": "Monsters can kill other monsters too.\n\nUse that to your avantage to complete the level.",
	"0_5": "The monk does not kill monsters but can move them.\n\nUse that ability to kill all monsters with your fighter.",
	"0_6": "Monsters can also be killed by pushing them against a wall.",
}

func getTutorial() -> String:
	if not TUTOS.has(String(ProfileData.currentLevel.x) + "_" + String(ProfileData.currentLevel.y)):
		return ""
	return TUTOS[String(ProfileData.currentLevel.x) + "_" + String(ProfileData.currentLevel.y)]
