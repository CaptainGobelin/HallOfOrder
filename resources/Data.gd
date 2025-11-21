extends Node

enum classes {Wizard, Monk, Paladin, Barbarian, Fighter, Ranger, Thief, Cleric, Warlock}
enum monsters {Goblin, Skeleton, DarkWizard, Slime, SlimeHurt, Bat, Spider, Doppleganger}
enum effects {Slash, Fire, Push}
enum sceneries {Pillar, Spikes, LeverOff, LeverOn, PillarOff, PillarOn}

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
const BI_TRANSITION = 2
const BIOMES = {
	0: ["BIOME_0", COLOR_GREEN, "TRANSITION_0"],
	1: ["BIOME_1", COLOR_ORANGE, "TRANSITION_1"],
	2: ["BIOME_2", COLOR_BLUE, "TRANSITION_2"],
}

const TUTOS = {
	"0_0": "TUTO_0",
	"0_1": "TUTO_1",
	"0_2": "TUTO_2",
	"0_3": "TUTO_3",
	"0_4": "TUTO_4",
	"0_5": "TUTO_5",
	"0_6": "TUTO_6",
}

func getTutorial() -> String:
	if not TUTOS.has(String(ProfileData.currentLevel.x) + "_" + String(ProfileData.currentLevel.y)):
		return ""
	return tr(TUTOS[String(ProfileData.currentLevel.x) + "_" + String(ProfileData.currentLevel.y)])

const LABEL_PLAY 			= 0
const LABEL_RESET 			= 1
const LABEL_MENU 			= 2
const LABEL_STOP 			= 3

const LABEL_START_GAME 		= 100
const LABEL_CHANGE_PROFILE 	= 101
const LABEL_OPTIONS 		= 102
const LABEL_EXIT 			= 103
const LABEL_LEVELS 			= 104
const LABEL_EXIT_MENU		= 105
const LABEL_RESUME			= 106

const LABEL_NEW			 	= 200
const LABEL_DELETE		 	= 201
const LABEL_CONFIRM		 	= 202
const LABEL_CANCEL		 	= 203
const LABEL_COPY		 	= 204
const LABEL_APPLY			= 205
const LABEL_BACK			= 206
const LABEL_UNKNOWN			= 207
const LABEL_HELP			= 208
const LABEL_CLOSE			= 209

const LABEL_BIOME			= 300

const LABEL_YES				= 400
const LABEL_NO				= 401
const LABEL_DRAG			= 402
const LABEL_CLICK			= 403
const LABEL_x05				= 404
const LABEL_x1				= 405
const LABEL_x2				= 406

var BUTTON_LABELS = {
	LABEL_PLAY: "BUTTONS_PLAY",
	LABEL_RESET: "BUTTONS_RESET",
	LABEL_MENU: "BUTTONS_MENU",
	LABEL_STOP: "BUTTONS_STOP",
	
	LABEL_START_GAME: "TITLE_BUTTON_PLAY",
	LABEL_CHANGE_PROFILE: "TITLE_BUTTON_PROFILE",
	LABEL_OPTIONS: "TITLE_BUTTON_OPTIONS",
	LABEL_EXIT: "TITLE_BUTTON_EXIT",
	LABEL_LEVELS: "LEVELS_TITLE",
	LABEL_EXIT_MENU: "PAUSE_MENU",
	LABEL_RESUME: "PAUSE_RESUME",
	
	LABEL_NEW: "PROFILE_BUTTON_NEW",
	LABEL_DELETE: "PROFILE_BUTTON_DELETE",
	LABEL_CONFIRM: "PROFILE_BUTTON_CONFIRM",
	LABEL_CANCEL: "PROFILE_BUTTON_CANCEL",
	LABEL_COPY: "PROFILE_BUTTON_COPY",
	LABEL_APPLY: "SETTINGS_APPLY",
	LABEL_BACK: "SETTINGS_BACK",
	LABEL_UNKNOWN: "LEVEL_UNKNOWN",
	LABEL_HELP: "?",
	LABEL_CLOSE: "X",
	
	LABEL_YES: "SETTINGS_YES",
	LABEL_NO: "SETTINGS_NO",
	LABEL_DRAG: "SETTINGS_DRAG",
	LABEL_CLICK: "SETTINGS_CLICK",
	LABEL_x05: "x0.5",
	LABEL_x1: "x1",
	LABEL_x2: "x2",
}

enum LargeButtonLabels {
	Play = LABEL_PLAY,
	Reset = LABEL_RESET,
	Menu = LABEL_MENU,
	Stop = LABEL_STOP,
}

enum MenuButtonLabels {
	New = LABEL_NEW,
	Delete = LABEL_DELETE,
	Confirm = LABEL_CONFIRM,
	Cancel = LABEL_CANCEL,
	Copy = LABEL_COPY,
	Apply = LABEL_APPLY,
	Back = LABEL_BACK,
	Unknown = LABEL_UNKNOWN,
	Help = LABEL_HELP,
	Close = LABEL_CLOSE,
}

enum LabelButtonLabels {
	Play = LABEL_START_GAME,
	ChooseProfile = LABEL_CHANGE_PROFILE,
	Options = LABEL_OPTIONS,
	Exit = LABEL_EXIT,
	ChooseLevel = LABEL_LEVELS,
	Menu = LABEL_EXIT_MENU,
	Resume = LABEL_RESUME,
	Unknown = LABEL_UNKNOWN,
}

enum SliderLabels {
	Yes = LABEL_YES,
	No = LABEL_NO,
	Drag = LABEL_DRAG,
	Click = LABEL_CLICK,
	x05 = LABEL_x05,
	x1 = LABEL_x1,
	x2 = LABEL_x2,
}

func _ready():
	for b in BIOMES.keys():
		BUTTON_LABELS[LABEL_BIOME+b] = "BIOME_" + String(b)
