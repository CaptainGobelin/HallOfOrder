extends Node

var texture: Texture = preload("res://sprites/pixel.png")

onready var viewport = get_viewport()
var minimum_size = Vector2(1920, 1080)

func _ready():
	var rid: RID = texture.get_rid()
	VisualServer.black_bars_set_images(rid, rid, rid, rid)
	viewport.connect("size_changed", self, "window_resize")
	window_resize()

func window_resize():
	var current_size = OS.get_window_size()
	var scale = 1080/current_size.y
	var new_size = current_size*scale
	
	var current_ar = current_size.x/current_size.y
	var default_ar = 16.0/9.0
	
	if current_ar > default_ar:
		new_size = Vector2(current_size.y*current_ar*scale, current_size.y*scale)
	viewport.set_size_override(true, new_size)

