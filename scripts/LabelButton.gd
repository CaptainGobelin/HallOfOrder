tool
extends Node2D

signal pressed

export(int) var buttonScale = 3 setget setScale
export(String) var buttonLabel = "Play" setget setLabel
export(bool) var enclosed = true setget setEnclosed

var world: int

func _ready():
	_on_TextureButton_mouse_exited()

func setScale(value: int):
	buttonScale = value
	scale = Vector2(value, value)

func setLabel(value: String):
	buttonLabel = value
	if has_node("Label"):
		$Label.text = value
		if not enclosed:
			$TextureButton.margin_left = $Label.margin_left
			$TextureButton.margin_right = $Label.margin_right

func setEnclosed(value: bool):
	enclosed = value
	if not enclosed:
		$Back.visible = false
		$TextureButton.margin_left = $Label.margin_left
		$TextureButton.margin_right = $Label.margin_right

func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_mouse_entered():
	$Back.visible = enclosed
	$Label.add_color_override("font_color", Colors.yellow)

func _on_TextureButton_mouse_exited():
	$Back.visible = false
	$Label.add_color_override("font_color", Colors.white)
