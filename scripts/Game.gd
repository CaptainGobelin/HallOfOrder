extends Node2D
class_name Game

export (int, "Menu", "Level", "Fast", "Normal", "Editor", "Choose") var gameMode = 2
export (int) var world = 0
export (int) var level = 0
export (Vector2) var cameraOffset = Vector2() setget setCameraOffset
export (float) var cameraRotation = 0.0 setget setCameraRotation

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
	set_process_input(true)
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
			ProfileData.firstLaunch = false
			Utils.changeScene("res://utils/LevelEditor/LevelEditor.tscn")
			return
		5:
			ProfileData.firstLaunch = false
			Utils.changeScene("res://scenes/LevelSelector.tscn")
			return
	ProfileData.firstLaunch = false
	LevelLoader.loadLevel(ProfileData.currentLevel.x, ProfileData.currentLevel.y)
	$AnimationPlayer.play("FadeIn")

func _input(event):
	if event.is_action_released("ui_cancel"):
		if $PauseScreen.visible:
			$PauseScreen._on_ResumeButton_pressed()
		else:
			pauseGame()

func nextLevel():
	LevelLoader.loadLevel(ProfileData.currentLevel.x, ProfileData.currentLevel.y + 1)
	$AnimationPlayer.play("FadeIn")

func pauseGame():
	$PauseScreen.visible = true

func colorize():
	$PauseScreen.colorize()

func setCameraOffset(value: Vector2):
	cameraOffset = value
	ScreenHandler.camera.offset = cameraOffset

func setCameraRotation(value: float):
	cameraRotation = value
	ScreenHandler.cameraHolder.rotation_degrees = cameraRotation
