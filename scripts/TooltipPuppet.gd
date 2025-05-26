tool
extends Node2D

export (int, "Hero", "Monster", "Scenery") var category = 0 setget setCategory
export (Data.classes) var heroType = 0 setget setHeroType
export (Data.monsters) var monsterType = 0 setget setMonsterType
export (Data.sceneries) var sceneryType = 0 setget setSceneryType
export (Vector2) var pos = Vector2(0, 0) setget setPos

func _ready():
	setCategory(category)

func colorize():
	var color = Utils.getBiomeColor()
	$Monster.self_modulate = color
	$Hero.self_modulate = color
	$Scenery.self_modulate = color

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
	category = 0
	setHero()

func setMonsterType(value: int):
	monsterType = value
	category = 1
	setMonster()

func setSceneryType(value: int):
	sceneryType = value
	category = 2
	setScenery()

func setHero():
	if not has_node("Hero"):
		return
	$Hero.frame = heroType
	$Hero/Colors.frame  = heroType + 9
	$Hero.visible = true
	$Monster.visible = false
	$Scenery.visible = false

func setMonster():
	if not has_node("Monster"):
		return
	$Monster.frame = monsterType
	$Hero.visible = false
	$Monster.visible = true
	$Scenery.visible = false

func setScenery():
	if not has_node("Scenery"):
		return
	$Scenery.frame = sceneryType
	$Hero.visible = false
	$Monster.visible = false
	$Scenery.visible = true

func setPos(value: Vector2):
	pos = value
	position = pos * 9

func crumble():
	$AnimationPlayer.play("Crumble")

func death():
	$AnimationPlayer.play("Death")

func spikes():
	$AnimationPlayer.play("Spikes")

func reset():
	$AnimationPlayer.play("RESET")
