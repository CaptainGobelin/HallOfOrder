extends Node

const NORMAL_MODE = 0
const SELECT_HERO_MODE = 1
const SELECT_TURN_MODE = 2

onready var arrow = preload("res://sprites/mouse/arrow.png")
onready var selected = preload("res://sprites/mouse/select.png")
onready var handOpen = preload("res://sprites/mouse/hand_open.png")
onready var handHold = preload("res://sprites/mouse/hand_hold.png")

var heroCursors: Dictionary = {}
var selection = null
var oldMousePos: Vector2
var selectionOffset: Vector2
var currentMode: int

func _ready():
	Signals.connect("change_scene", self, "resetScene")
	loadCursors()
	normalMode()

func resetScene():
	selection = null
	oldMousePos = Vector2()
	selectionOffset = Vector2()
	normalMode()

func normalMode():
	currentMode = NORMAL_MODE
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(4, 4))
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
			placeHero(selectedNode.pos)
		else:
			selection.cancelPick()
	currentMode = SELECT_HERO_MODE
	selection = selectedNode
	ButtonHandler.disableTurnButtons()
	Ref.turnOrder.get_node("TextureButton").visible = false
	Input.set_custom_mouse_cursor(getHeroCursor(selection.type, "M", "green"), Input.CURSOR_ARROW, Vector2(4, 4))
	oldMousePos = get_viewport().get_mouse_position()
	Ref.ui.get_node("Board").enableButton()
	set_process_input(true)

func selectTurnMode(selectedNode):
	currentMode = SELECT_TURN_MODE
	Input.set_custom_mouse_cursor(handHold, Input.CURSOR_ARROW, Vector2(4, 4))
	selection = selectedNode
	selection.get_node("Card").z_index = 2000
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

func loadCursors():
	var path = "res://sprites/mouse/heroes/"
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not file_name.ends_with(".png"):
				file_name = dir.get_next()
				continue
			var info = file_name.trim_suffix(".png").split("_")
			if not heroCursors.has(info[2]):
				heroCursors[info[2]] = {}
			if not heroCursors[info[2]].has(info[1]):
				heroCursors[info[2]][info[1]] = {}
			heroCursors[info[2]][info[1]][info[0]] = load(path + file_name)
			file_name = dir.get_next()

func getHeroCursor(type: int, size: String, color: String):
	return heroCursors[size][color][String(type)]

func placeHero(cell: Vector2):
	assert(selection != null)
	if Ref.board.isCellTaken(cell):
		return
	selection.placeOnBoard(cell)
	selection = null
	normalMode()

func handCursor():
	Input.set_custom_mouse_cursor(handOpen, Input.CURSOR_ARROW, Vector2(4, 4))

func arrowCursor():
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(4, 4))
