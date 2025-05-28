extends Node

signal play_order
signal change_scene

signal fullscreen_changed
signal screenSize_changed

func playOrder():
	emit_signal("play_order")

func changeSceneSignal():
	emit_signal("change_scene")

func allSettings():
	fullscreenChanged()
	screenSizeChanged()

func fullscreenChanged():
	emit_signal("fullscreen_changed")

func screenSizeChanged():
	emit_signal("screenSize_changed")
