extends Node2D
class_name TurnOrderObject

const CARD_NORMAL = 15
const CARD_HOVER = 16
const SLOT_NORMAL = 54
const SLOT_HOVER = 55
const PRINT_CHAR_NORMAL = 88
const PRINT_CHAR_HOVER = 89
const PRINT_SKULL_NORMAL = 94
const PRINT_SKULL_HOVER = 95

onready var animator = $AnimationPlayer

var posInList: int setget setPosInList
var listSize: int
var currentShift: int = 0
var isActive = false
var isEmpty = true
var isLast = true
var isLocked = false
var initialPosition: Vector2 = Vector2()
var contained = null

func _ready():
	hide()
	initialPosition = global_position
	ButtonHandler.register(self, ButtonHandler.Types.Turn)
	outline(false)

func init(size: int, pos: int):
	setPos(size, pos)
	$TextureButton.visible = true
	isActive = true
	visible = true
	freeSlot()
	currentShift = 0
	initialPosition = global_position

func colorize():
	var color = Utils.getBiomeColor()
	$Card.self_modulate = color
	$Card/Hero.self_modulate = color
	$Card/Monster.modulate = color
	$Card/Slot.modulate = color
	$Card/Print.modulate = color
	$Arrow.modulate = color

func unuse():
	$TextureButton.visible = false
	isActive = false
	visible = false
	freeSlot()
	currentShift = 0
	initialPosition = global_position

func freeSlot():
	contained = null
	isEmpty = true
	isLocked = false
	$Card/Hero.visible = false
	$Card/Monster.visible = false
	$Card/Slot.visible = true
	$Card/Print.frame = PRINT_CHAR_NORMAL
	outline(false)

func setPos(size: int, pos: int):
	isLast = pos == (size-1)
	position.x = 17 * pos
	setPosInList(pos)
	currentShift = 0
	$Arrow.visible = not isLast

func enable():
	if isActive:
		$TextureButton.visible = true

func disable():
	$TextureButton.visible = false

func hide():
	$TextureButton.visible = false
	isActive = false
	isEmpty = true
	isLocked = false
	visible = false

func cancelPick():
	$TextureButton.visible = true
	$Card.z_index = 0
	ButtonHandler.enableTurnButtons()
	_on_TextureButton_mouse_exited()
	$Card.position = Vector2(0, 0)

func _on_TextureButton_mouse_entered():
	if $TextureButton.disabled:
		return
	$Card.frame = CARD_HOVER
	if isEmpty:
		$Card/Slot.frame = SLOT_HOVER
		MouseHandler.handCursor()
	elif isLocked:
		$Card/Print.frame = PRINT_SKULL_HOVER
	else:
		$Card/Print.frame = PRINT_CHAR_HOVER
		MouseHandler.handCursor()
	if contained != null:
		contained.outline()

func _on_TextureButton_mouse_exited():
	$Card.frame = CARD_NORMAL
	if isEmpty:
		$Card/Slot.frame = SLOT_NORMAL
	elif isLocked:
		$Card/Print.frame = PRINT_SKULL_NORMAL
	else:
		$Card/Print.frame = PRINT_CHAR_NORMAL
	MouseHandler.arrowCursor()
	if contained != null:
		contained.outline(false)

func _on_TextureButton_pressed():
	if isLocked:
		return
	$TextureButton.visible = false
	_on_TextureButton_mouse_entered()
	MouseHandler.selectTurnMode(self)
	get_parent().get_parent().currentPosList = posInList
	
func backToPos():
	match currentShift:
		-1:
			animator.play_backwards("SwapOneLeft")
		1:
			animator.play_backwards("SwapOneRight")
		-2:
			animator.play_backwards("SwapTwoLeft")
		2:
			animator.play_backwards("SwapTwoRight")
	currentShift = 0

func moveRight():
	if currentShift == 1:
		return
	currentShift = 1
	animator.play("SwapOneRight")

func moveRightTwo():
	if currentShift == 2:
		return
	currentShift = 2
	animator.play("SwapTwoRight")

func moveLeft():
	if currentShift == -1:
		return
	currentShift = -1
	animator.play("SwapOneLeft")

func moveLeftTwo():
	if currentShift == -2:
		return
	currentShift = -2
	animator.play("SwapTwoLeft")

func setPosInList(value: int):
	posInList = value
	$Card/Label.text = String(value)

func setHeroType(type: int):
	$Card/Hero.frame  = type
	$Card/Hero/Colors.frame  = type + 9
	$Card/Outline.modulate = Colors.cyan

func setMonsterType(type: int):
	$Card/Monster.frame = type
	$Card/Outline.modulate = Colors.red

func outline(value: bool = true):
	$Card/Outline.visible = value
