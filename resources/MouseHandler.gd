extends Node

const NORMAL_MODE = 0
const SELECT_HERO_MODE = 1
const SELECT_TURN_MODE = 2

onready var arrows = {
	ProfileData.CURSOR_S: preload("res://sprites/mouse/arrow_S.png"),
	ProfileData.CURSOR_M: preload("res://sprites/mouse/arrow_M.png"),
	ProfileData.CURSOR_L: preload("res://sprites/mouse/arrow_L.png"),
}
onready var handOpens = {
	ProfileData.CURSOR_S: preload("res://sprites/mouse/hand_open_S.png"),
	ProfileData.CURSOR_M: preload("res://sprites/mouse/hand_open_M.png"),
	ProfileData.CURSOR_L: preload("res://sprites/mouse/hand_open_L.png"),
}
onready var handHolds = {
	ProfileData.CURSOR_S: preload("res://sprites/mouse/hand_hold_S.png"),
	ProfileData.CURSOR_M: preload("res://sprites/mouse/hand_hold_M.png"),
	ProfileData.CURSOR_L: preload("res://sprites/mouse/hand_hold_L.png"),
}

var heroCursors: Dictionary = {}
var selection = null
var oldMousePos: Vector2
var selectionOffset: Vector2
var currentMode: int

func _ready():
	Signals.connect("change_scene", self, "resetScene")
	var path = "res://sprites/mouse/heroes/"
	for i in range(9):
		for j in range(Data.BIOMES.keys().size()):
			for s in ["S", "M", "L"]:
				if not heroCursors.has(s):
					heroCursors[s] = {}
				if not heroCursors[s].has(String(j)):
					heroCursors[s][String(j)] = {}
				var file = String(i) + "_" + String(j) + "_" + s + ".png"
				heroCursors[s][String(j)][String(i)] = ResourceLoader.load(path + file)
	normalMode()

func resetScene():
	selection = null
	oldMousePos = Vector2()
	selectionOffset = Vector2()
	normalMode()

func normalMode():
	currentMode = NORMAL_MODE
	Input.set_custom_mouse_cursor(arrows[ProfileData.cursorSize], Input.CURSOR_ARROW, Vector2(4, 4))
	if selection != null:
		selection.cancelPick()
		selection = null
	if Ref.ui != null:
		Ref.ui.get_node("Board").disableButton()
	ButtonHandler.enableTurnButtons()
	set_process_input(false)

func selectHeroMode(selectedNode):
	if currentMode == SELECT_HERO_MODE:
		if selectedNode.onBoard:
			var p = selectedNode.pos
			selectedNode.placeOnPool()
			placeHero(p)
		else:
			selection.cancelPick()
	currentMode = SELECT_HERO_MODE
	selection = selectedNode
	Ref.ui.hideTooltip()
	ButtonHandler.disableTurnButtons()
	Ref.turnOrder.get_node("TextureButton").visible = false
	Input.set_custom_mouse_cursor(getHeroCursor(selection.type), Input.CURSOR_ARROW, Vector2(4, 4))
	oldMousePos = get_viewport().get_mouse_position()
	Ref.ui.get_node("Board").enableButton()
	set_process_input(true)

func selectTurnMode(selectedNode):
	currentMode = SELECT_TURN_MODE
	Input.set_custom_mouse_cursor(handHolds[ProfileData.cursorSize], Input.CURSOR_ARROW, Vector2(4, 4))
	selection = selectedNode
	selection.get_node("Card").z_index = 2
	ButtonHandler.disableTurnButtons()
	Ref.turnOrder.get_node("TextureButton").visible = true
	oldMousePos = get_viewport().get_mouse_position()
	selectionOffset = oldMousePos - selection.get_node("Card").global_position
	set_process_input(true)

func _input(event):
	if event.is_action_released("right_click"):
		normalMode()
	if event.is_action_released("left_click"):
		if currentMode == SELECT_TURN_MODE:
			Ref.turnOrder.validatePick()
			normalMode()
	elif event is InputEventMouseMotion:
		if currentMode == SELECT_TURN_MODE:
			var mouse_pos = event.position
			selection.get_node("Card").global_position = mouse_pos - selectionOffset

func getHeroCursor(type: int):
	if ProfileData.cursorSize == ProfileData.CURSOR_S:
		return heroCursors["S"][String(ProfileData.currentLevel.x)][String(type)]
	elif ProfileData.cursorSize == ProfileData.CURSOR_M:
		return heroCursors["M"][String(ProfileData.currentLevel.x)][String(type)]
	return heroCursors["L"][String(ProfileData.currentLevel.x)][String(type)]

func placeHero(cell: Vector2):
	assert(selection != null)
	if Ref.board.isCellTaken(cell):
		return
	selection.placeOnBoard(cell)
	selection = null
	normalMode()

func handCursor():
	Input.set_custom_mouse_cursor(handOpens[ProfileData.cursorSize], Input.CURSOR_ARROW, Vector2(4, 4))

func arrowCursor():
	Input.set_custom_mouse_cursor(arrows[ProfileData.cursorSize], Input.CURSOR_ARROW, Vector2(4, 4))
