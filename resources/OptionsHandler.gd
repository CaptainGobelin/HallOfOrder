extends Node

func _ready():
	Signals.connect("cursorSize_changed", self, "applyCursorSize")
	Signals.connect("fullscreen_changed", self, "applyFullscreen")
	Signals.connect("screenSize_changed", self, "applyScreenSize")

func applySettings():
	applyFullscreen()
	applyScreenSize()

func applyCursorSize():
	MouseHandler.arrowCursor()

func applyFullscreen():
	OS.window_fullscreen = ProfileData.fullscreen

func applyScreenSize():
	var old = OS.window_size
	OS.window_size = ProfileData.screenSize
	OS.window_position.x += (old.x - OS.window_size.x)/2
	OS.window_position.x = max(0, OS.window_position.x)
	OS.window_position.y += (old.y - OS.window_size.y)/2
	OS.window_position.y = max(0, OS.window_position.y)

func getResolutionOptions() -> PoolVector2Array:
	var maxSize = OS.get_screen_size()
	var result = [Vector2(480, 360)]
	var factor = 2
	while maxSize.x > (480 * factor) and maxSize.y > (360 * factor): 
		result.append(Vector2(480 * factor, 360 * factor))
		factor += 1
	return result
