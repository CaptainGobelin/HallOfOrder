extends Node2D
class_name Game

export (int, "Menu", "Level", "Fast", "Normal", "Editor", "Choose") var gameMode = 2
export (int) var world = 0
export (int) var level = 0

onready var effectScene = preload("res://scenes/Effect.tscn")
onready var heroScene = preload("res://scenes/Hero.tscn")
onready var monsterScene = preload("res://scenes/Monster.tscn")
onready var sceneryScene = preload("res://scenes/Scenery.tscn")

onready var effects = $Effects

var currentLevel:Vector2 = Vector2(0, 0)

func _ready():
	Ref.game = self
	Ref.utils = $Utils
	Ref.monsters = $Monsters
	Ref.sceneries = $Sceneries
	if ProfileData.skipGamemode:
		gameMode = 3
		currentLevel = ProfileData.currentLevel
	else:
		ProfileData.skipGamemode = true
	match gameMode:
		0:
			Utils.changeScene("res://scenes/TitleScreen.tscn")
			return
		1:
			ProfileData.currentLevel = Vector2(world, level)
		2:
			ProfileData.currentLevel = Vector2(0, 0)
		3:
			pass
		4:
			Utils.changeScene("res://utils/LevelEditor/LevelEditor.tscn")
			return
		5:
			Utils.changeScene("res://scenes/LevelSelector.tscn")
			return
	LevelLoader.loadLevel(ProfileData.currentLevel.x, ProfileData.currentLevel.y)

func nextLevel():
	LevelLoader.loadLevel(ProfileData.currentLevel.x, ProfileData.currentLevel.y + 1)

func pauseGame():
	$PauseScreen.visible = true

func colorize():
	$PauseScreen.colorize()
