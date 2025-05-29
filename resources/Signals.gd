extends Node

signal play_order
signal change_scene

signal cursorSize_changed
signal fullscreen_changed
signal screenSize_changed

func playOrder():
	emit_signal("play_order")

func changeSceneSignal():
	emit_signal("change_scene")

func allSettings():
	cursorSizeChanged()
	fullscreenChanged()
	screenSizeChanged()

func cursorSizeChanged():
	emit_signal("cursorSize_changed")

func fullscreenChanged():
	emit_signal("fullscreen_changed")

func screenSizeChanged():
	emit_signal("screenSize_changed")
