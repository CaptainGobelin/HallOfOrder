extends Node

enum classes {Wizard, Monk, Paladin, Barbarian, Fighter, Ranger, Thief, Cleric, Warlock}
enum monsters {Goblin, Skeleton, DarkWizard, Slime, SlimeHurt}
enum effects {Slash, Fire, Push}
enum sceneries {Pillar, Spikes}

const DIR_UP = 0
const DIR_RIGHT = 1
const DIR_DOWN = 2
const DIR_LEFT = 3

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
