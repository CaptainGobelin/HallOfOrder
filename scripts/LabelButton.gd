tool
extends Node2D

signal pressed

export(int) var buttonScale = 3 setget setScale
export(String) var buttonLabel = "Play" setget setLabel
export(bool) var enclosed = true setget setEnclosed

var world: int

func _ready():
	setLabel(buttonLabel)
	_on_TextureButton_mouse_exited()

func colorize():
	var color = Utils.getBiomeColor()
	$Back.modulate = color

func setScale(value: int):
	buttonScale = value
	scale = Vector2(value, value)

func setLabel(value: String):
	buttonLabel = value
	if has_node("Label"):
		$Label.text = value
		if not enclosed:
			$Label.visible = false
			$Label.visible = true
			$TextureButton.rect_position = $Label.rect_position - Vector2(4, 0)
			$TextureButton.rect_size = $Label.rect_size + Vector2(8, 0)

func setEnclosed(value: bool):
	enclosed = value
	if has_node("Label"):
		if not enclosed:
			$Back.visible = false
			$Label.visible = false
			$Label.visible = true
			$TextureButton.rect_position = $Label.rect_position - Vector2(4, 0)
			$TextureButton.rect_size = $Label.rect_size + Vector2(8, 0)

func disable():
	$TextureButton.visible = false
	$Label.add_color_override("font_color", Colors.shade3 * Utils.getBiomeColor())

func enable():
	$TextureButton.visible = true
	$Label.remove_color_override("font_color")

func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_mouse_entered():
	$Back.visible = enclosed
	$Label.add_color_override("font_color", Colors.yellow)

func _on_TextureButton_mouse_exited():
	$Back.visible = false
	$Label.add_color_override("font_color", Colors.white)
