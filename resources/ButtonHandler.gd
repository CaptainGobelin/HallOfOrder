extends Node

enum Types {Menu, Turn, Entity}
enum Icons {Play = 41, Reset = 47, Stop = 53, Sound = 78, NoSound = 79, Menu = 80,
	NormalSpeed = 81, DoubleSpeed = 82, Fullscreen = 90, Smallscreen = 91,
	Unroll = 92, Roll = 93}

var menuButtons: Array
var turnButtons: Array
var entityButtons: Array

func _ready():
	Signals.connect("change_scene", self, "resetScene")

func resetScene():
	menuButtons = []
	turnButtons = []
	entityButtons = []

func register(button: Node, type: int):
	match type:
		Types.Menu:
			menuButtons.append(button)
		Types.Turn:
			turnButtons.append(button)
		Types.Entity:
			entityButtons.append(button)

func flush():
	entityButtons.clear()

func disableMenuButtons():
	for b in menuButtons:
		b.disable()

func enableMenuButtons():
	for b in menuButtons:
		b.enable()

func disableTurnButtons():
	for b in turnButtons:
		b.disable()

func enableTurnButtons():
	for b in turnButtons:
		b.enable()

func disableEntityButtons():
	for b in entityButtons:
		b.disable()

func enableEntityButtons():
	for b in entityButtons:
		b.enable()

func buttonPressed(type: int):
	MouseHandler.normalMode()
	match type:
		Icons.Play:
			playMode()
		Icons.Reset:
			reset()
		Icons.Stop:
			BattleHandler.stopBattle()
			normalMode()
		Icons.Sound:
			Ref.ui.get_node("NoSoundButton").visible = true
			Ref.ui.get_node("SoundButton").visible = false
		Icons.NoSound:
			Ref.ui.get_node("NoSoundButton").visible = false
			Ref.ui.get_node("SoundButton").visible = true
		Icons.NormalSpeed:
			Ref.ui.get_node("NormalSpeedButton").visible = false
			Ref.ui.get_node("DoubleSpeedButton").visible = true
		Icons.DoubleSpeed:
			Ref.ui.get_node("NormalSpeedButton").visible = true
			Ref.ui.get_node("DoubleSpeedButton").visible = false
		Icons.Fullscreen:
			Ref.ui.get_node("FullscreenButton").visible = false
			Ref.ui.get_node("SmallscreenButton").visible = true
			OS.window_fullscreen = true
		Icons.Smallscreen:
			Ref.ui.get_node("FullscreenButton").visible = true
			Ref.ui.get_node("SmallscreenButton").visible = false
			OS.window_fullscreen = false
		Icons.Roll:
			Ref.ui.get_node("InfoBox").roll()
		Icons.Unroll:
			Ref.ui.get_node("InfoBox").unroll()
		_:
			print("Unknown button")

func playMode():
	Ref.ui.get_node("PlayButton").visible = false
	Ref.ui.get_node("StopButton").visible = true
	disableTurnButtons()
	disableMenuButtons()
	disableEntityButtons()
	Ref.ui.get_node("StopButton").enable()
	BattleHandler.playBattle()

func normalMode():
	Ref.ui.get_node("PlayButton").visible = true
	Ref.ui.get_node("StopButton").visible = false
	enableEntityButtons()
	enableMenuButtons()
	enableTurnButtons()

func reset():
	for h in Ref.heroes.get_children():
		h.placeOnPool()
	normalMode()
