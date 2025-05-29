extends Node2D
class_name CursorExctrator

var classes = {
	"wizard": Data.classes.Wizard,
	"monk": Data.classes.Monk,
	"fighter": Data.classes.Fighter,
	"barbarian": Data.classes.Barbarian,
	"ranger": Data.classes.Ranger,
	"cleric": Data.classes.Cleric,
	"warlock": Data.classes.Warlock,
	"thief": Data.classes.Thief,
	"paladin": Data.classes.Paladin,
}

var sizes = {
	"S": 3,
	"M": 4,
	"L": 6
}

var colors = {
	"green": Color(1, 1, 1, 1)
}
# ===================== WARNING =====================
# This standalone tool should be run with GLES2
# Otherwise colors are not correct 

func _ready():
	get_viewport().transparent_bg = true
	for biome in Data.BIOMES.keys():
		var color = Data.BIOMES[biome][Data.BI_COLOR]
		$Pixel.visible = false
		$Arrow.visible = true
		$Cursor.visible = true
		for s in sizes.keys():
			get_viewport().size = Vector2(12, 12)
			get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, sizes[s] * Vector2(12, 12), 1)
			$Cursor.scale = Vector2(sizes[s], sizes[s])
			$Arrow.scale = Vector2(sizes[s]* 0.25, sizes[s]* 0.25)
			for type in range(9):
				$Cursor.frame  = type
				$Cursor/Colors.frame  = type + 9
				$Cursor.self_modulate = color
				yield(VisualServer, "frame_post_draw")
				var capture = get_viewport().get_texture().get_data()
#					capture.convert(Image.FORMAT_RGBAF)
				capture.flip_y()
				var filename = String(type) + "_" + String(biome) + "_" + s
				capture.save_png("sprites/mouse/heroes/" + filename + ".png")
		$Pixel.visible = true
		$Arrow.visible = false
		$Cursor.visible = false
		get_viewport().size = Vector2(1, 1)
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, Vector2(12, 12), 1)
		$Pixel.modulate = color
		yield(VisualServer, "frame_post_draw")
		var capture = get_viewport().get_texture().get_data()
#		capture.convert(Image.FORMAT_RGBAF)
		var filename = String(biome)
		capture.save_png("sprites/pixel/" + filename + ".png")
	get_tree().quit()
