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
	Signals.connect("button_hovered", self, "buttonHovered")
	Signals.connect("button_unhovered", self, "buttonUnhovered")

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
			ProfileData.animSpeed = ProfileData.ANIM_FAST
			Signals.emit_signal("animSpeed_changed")
			ProfileData.saveProfile()
		Icons.DoubleSpeed:
			ProfileData.animSpeed = ProfileData.ANIM_NORMAL
			Signals.emit_signal("animSpeed_changed")
			ProfileData.saveProfile()
		Icons.Fullscreen:
			ProfileData.fullscreen = false
			Signals.emit_signal("fullscreen_changed")
			ProfileData.saveSettings()
		Icons.Smallscreen:
			ProfileData.fullscreen = true
			Signals.emit_signal("fullscreen_changed")
			ProfileData.saveSettings()
		Icons.Roll:
			Ref.ui.get_node("InfoBox").roll()
		Icons.Unroll:
			Ref.ui.get_node("InfoBox").unroll()
		Icons.Menu:
			Ref.game.pauseGame()
		_:
			print("Unknown button")

func buttonHovered(type: int):
	match type:
		Icons.Sound:
			Ref.ui.setTooltip("Mute sounds")
		Icons.NoSound:
			Ref.ui.setTooltip("Unmute sounds")
		Icons.NormalSpeed:
			Ref.ui.setTooltip("Speed up animations")
		Icons.DoubleSpeed:
			Ref.ui.setTooltip("Speed down animation")
		Icons.Fullscreen:
			Ref.ui.setTooltip("Windowed mode")
		Icons.Smallscreen:
			Ref.ui.setTooltip("Fullscreen mode")
		Icons.Menu:
			Ref.ui.setTooltip("Menu")

func buttonUnhovered():
	Ref.ui.hideTooltip()

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
