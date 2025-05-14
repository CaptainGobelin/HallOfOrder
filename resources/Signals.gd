extends Node

signal play_order
signal change_scene

func playOrder():
	emit_signal("play_order")

func changeSceneSignal():
	emit_signal("change_scene")
