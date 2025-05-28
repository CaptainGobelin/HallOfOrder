extends Node

func _ready():
	Signals.connect("fullscreen_changed", self, "applyFullscreen")
	Signals.connect("screenSize_changed", self, "applyScreenSize")

func applySettings():
	applyFullscreen()
	applyScreenSize()

func applyFullscreen():
	OS.window_fullscreen = ProfileData.fullscreen

func applyScreenSize():
	var old = OS.window_size
	OS.window_size = ProfileData.screenSize
	OS.window_position.x += (old.x - OS.window_size.x)/2
	OS.window_position.y += (old.y - OS.window_size.y)/2

func getResolutionOptions() -> PoolVector2Array:
	var maxSize = OS.get_screen_size()
	var result = [Vector2(480, 360)]
	var factor = 2
	while maxSize.x >= (480 * factor) and maxSize.y >= (360 * factor): 
		result.append(Vector2(480 * factor, 360 * factor))
		factor += 1
	result.append(maxSize)
	return result
