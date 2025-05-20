tool
extends Node2D

signal pressed

export(Vector2) var size = Vector2(1, 1) setget setSize
export(String) var label = "Button" setget setLabel

var enabled: bool = true

func _ready():
	$Light.color = Colors.shade3
	$Shadow.color = Colors.shade5

func setSize(v: Vector2):
	size = v
	if not has_node("Block"):
		return
	$Light.margin_right = v.x * 45
	$Light.margin_bottom = v.y * 45
	$Shadow.margin_right = v.x * 45
	$Shadow.margin_bottom = v.y * 45
	$Block.margin_right = v.x * 45 - 2
	$Block.margin_bottom = v.y * 45 - 2
	$Label.margin_right = v.x * 45
	$Label.margin_bottom = v.y * 45
	$TextureButton.margin_right = v.x * 45
	$TextureButton.margin_bottom = v.y * 45

func setLabel(value: String):
	label = value
	if not has_node("Block"):
		return
	$Label.text = value

func disable():
	$Label.add_color_override("font_color", Colors.shade3)
	$Light.color = Colors.shade3
	$Block.color = Colors.shade4
	$Shadow.color = Colors.shade6
	$TextureButton.visible = false
	enabled = false

func enable():
	$Label.add_color_override("font_color", Colors.white)
	$Light.color = Colors.shade3
	$Block.color = Colors.shade4
	$Shadow.color = Colors.shade5
	$TextureButton.visible = true
	enabled = true

func _on_TextureButton_mouse_entered():
	$Light.color = Colors.shade2
	$Block.color = Colors.shade3

func _on_TextureButton_mouse_exited():
	$Light.color = Colors.shade3
	$Block.color = Colors.shade4

func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_button_down():
	$Light.color = Colors.shade5
	$Shadow.color = Colors.shade5
	$Block.color = Colors.shade4

func _on_TextureButton_button_up():
	$Light.color = Colors.shade2
	$Shadow.color = Colors.shade5
	$Block.color = Colors.shade3

func _on_TextureButton_visibility_changed():
	if not enabled:
		return
	_on_TextureButton_mouse_exited()
