extends Node

var texture: Texture = preload("res://sprites/pixel.png")
var pixels: Dictionary = {}

onready var viewport = get_viewport()
onready var environment = WorldEnvironment.new()
var minimum_size = Vector2(1920, 1080)
var camera = Camera2D.new()
var cameraHolder = Node2D.new()

func _ready():
	camera.current = true
	camera.offset = Vector2(0, 0)
	camera.rotating = true
	cameraHolder.rotation_degrees = 0.0
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_CANVAS
	environment.environment.adjustment_enabled = true
	add_child(environment)
	add_child(cameraHolder)
	cameraHolder.add_child(camera)
	Signals.connect("change_scene", self, "reset")
	window_resize()
	loadPixels()

func colorize():
	VisualServer.set_default_clear_color(Colors.shade6 * Utils.getBiomeColor())

func reset():
	camera.offset = Vector2(0, 0)
	cameraHolder.rotation_degrees = 0.0
	VisualServer.set_default_clear_color(Colors.shade6)

func window_resize():
	camera.position = (viewport.size)/2.0

func loadPixels():
	for biome in Data.BIOMES.keys():
		pixels[biome] = load("res://sprites/pixel/" + String(biome) +".png")

func setBrightness(value: float):
	environment.environment.adjustment_brightness = value
	pass
