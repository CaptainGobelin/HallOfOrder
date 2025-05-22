extends Node2D
class_name Ui

func _ready():
	Ref.ui = self

func _on_MenuButton_pressed():
	#TODO this is a temp behavior
	Utils.changeScene("res://scenes/TitleScreen.tscn")

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
