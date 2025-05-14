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
	"M": 4
}

var colors = {
	"green": Color(1, 1, 1, 1)
}

func _ready():
	get_viewport().transparent_bg = true
	for s in sizes.keys():
		get_viewport().size = Vector2(12, 12)
		get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_VIEWPORT, SceneTree.STRETCH_ASPECT_KEEP, sizes[s] * Vector2(12, 12), 1)
		$Cursor.scale = Vector2(sizes[s], sizes[s])
		$Arrow.scale = Vector2(sizes[s]* 0.25, sizes[s]* 0.25)
		for c in range(9):
			$Cursor.frame  = c
			$Cursor/Colors.frame  = c + 9
			for col in colors.keys():
				$Cursor.self_modulate = colors[col]
				yield(VisualServer, "frame_post_draw")
				var capture = get_viewport().get_texture().get_data()
				capture.convert(Image.FORMAT_RGBA8)
				capture.flip_y()
				var filename = String(c) + "_" + col + "_" + s
				capture.save_png("sprites/mouse/heroes/" + filename + ".png")
	get_tree().quit()
