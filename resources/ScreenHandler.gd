extends Node

var texture: Texture = preload("res://sprites/pixel.png")
var pixels: Dictionary = {}

onready var viewport = get_viewport()
onready var environment = WorldEnvironment.new()
var minimum_size = Vector2(1920, 1080)

func _ready():
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_CANVAS
	environment.environment.adjustment_enabled = true
	add_child(environment)
	Signals.connect("change_scene", self, "decolorize")
	var rid: RID = texture.get_rid()
	VisualServer.black_bars_set_images(rid, rid, rid, rid)
	viewport.connect("size_changed", self, "window_resize")
	window_resize()
	loadPixels()

func colorize():
	var rid: RID = pixels[int(ProfileData.currentLevel.x)].get_rid()
	VisualServer.black_bars_set_images(rid, rid, rid, rid)
	VisualServer.set_default_clear_color(Colors.shade6 * Utils.getBiomeColor())

func decolorize():
	var rid: RID = texture.get_rid()
	VisualServer.black_bars_set_images(rid, rid, rid, rid)
	VisualServer.set_default_clear_color(Colors.shade6)

func window_resize():
	var current_size = OS.get_window_size()
	var scale = 1080/current_size.y
	var new_size = current_size*scale
	
	var current_ar = current_size.x/current_size.y
	var default_ar = 16.0/9.0
	
	if current_ar > default_ar:
		new_size = Vector2(current_size.y*current_ar*scale, current_size.y*scale)
	viewport.set_size_override(true, new_size)

func loadPixels():
	for biome in Data.BIOMES.keys():
		pixels[biome] = load("res://sprites/pixel/" + String(biome) +".png")

func setBrightness(value: float):
	environment.environment.adjustment_brightness = value
