extends Node2D
class_name Ui

func _ready():
	Ref.ui = self
	Signals.connect("fullscreen_changed", self, "toggleFullscreenButton")
	Signals.connect("animSpeed_changed", self, "toggleAnimSpeedButton")
	toggleFullscreenButton()
	toggleAnimSpeedButton()

func colorize():
	var color = Utils.getBiomeColor()
	$Board.modulate = color
	$ResetButton.modulate = color
	$PlayButton.modulate = color
	$StopButton.modulate = color
	$MenuButton.modulate = color
	$NormalSpeedButton.modulate = color
	$DoubleSpeedButton.modulate = color
	$FullscreenButton.modulate = color
	$SmallscreenButton.modulate = color
	$SoundButton.modulate = color
	$NoSoundButton.modulate = color
	$Title.colorize()
	$HeroPool.colorize()
	$InfoBox.colorize()
	$TurnOrder.colorize()
	Ref.game.colorize()

func showTooltip(type: int):
	$InfoBox.showTooltip(type)

func hideTooltip():
	$InfoBox.hideTooltip()

func toggleFullscreenButton():
	if ProfileData.fullscreen:
		Ref.ui.get_node("FullscreenButton").visible = true
		Ref.ui.get_node("SmallscreenButton").visible = false
	else:
		Ref.ui.get_node("FullscreenButton").visible = false
		Ref.ui.get_node("SmallscreenButton").visible = true

func toggleAnimSpeedButton():
	if ProfileData.animSpeed == ProfileData.ANIM_NORMAL:
		Ref.ui.get_node("NormalSpeedButton").visible = true
		Ref.ui.get_node("DoubleSpeedButton").visible = false
	else:
		Ref.ui.get_node("NormalSpeedButton").visible = false
		Ref.ui.get_node("DoubleSpeedButton").visible = true
