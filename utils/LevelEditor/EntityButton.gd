tool
extends Node2D

export (int, "Hero", "Monster", "Scenery") var category = 0 setget setCategory
export (Data.classes) var heroType = 0 setget setHeroType
export (Data.monsters) var monsterType = 0 setget setMonsterType
export (Data.sceneries) var sceneryType = 0 setget setSceneryType

enum States {NO, BOARD, POOL, TURN}

var type: int = 0
var pos: Vector2 = Vector2(0, 0)
var poolPos: int = 0
var currentState = States.NO
var isHero: bool = false
var isMonster: bool = false
var isScenery: bool = false

func _ready():
	setType(type + 100 * category)

func setType(value: int):
	if value >= 200:
		sceneryType = value - 200
		setCategory(2)
	elif value >= 100:
		monsterType = value - 100
		setCategory(1)
	else:
		heroType = value
		setCategory(0)

func setCategory(value: int):
	category = value
	match category:
		0:
			setHeroType(heroType)
		1:
			setMonsterType(monsterType)
		2:
			setSceneryType(sceneryType)

func setHeroType(value: int):
	heroType = value
	if category == 0:
		type = value
		setHero()

func setMonsterType(value: int):
	monsterType = value
	if category == 1:
		type = value
		setMonster()

func setSceneryType(value: int):
	sceneryType = value
	if category == 2:
		type = value
		setScenery()

func setHero():
	if not has_node("Hero"):
		return
	$Hero.frame = type
	$Hero/Colors.frame  = type + 9
	$Hero.visible = true
	$Monster.visible = false
	$Scenery.visible = false
	isHero = true
	isMonster = false
	isScenery = false

func setMonster():
	if not has_node("Monster"):
		return
	$Monster.frame = type
	$Hero.visible = false
	$Monster.visible = true
	$Scenery.visible = false
	isHero = false
	isMonster = true
	isScenery = false

func setScenery():
	if not has_node("Scenery"):
		return
	$Scenery.frame = type
	$Hero.visible = false
	$Monster.visible = false
	$Scenery.visible = true
	isHero = false
	isMonster = false
	isScenery = true

func boardMode():
	currentState = States.BOARD
	$Button.button_mask =  BUTTON_RIGHT
	$Button.connect("pressed", self, "delete")

func delete():
	queue_free()
