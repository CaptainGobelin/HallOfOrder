tool
extends Node2D

signal pressed

export(int) var buttonScale = 3 setget setScale
export(Data.LabelButtonLabels) var buttonLabel = Data.LabelButtonLabels.Play setget setLabel
export(bool) var enclosed = true setget setEnclosed

var world: int

func _ready():
	Signals.connect("language_changed", self, "updateTranslations")
	setLabel(buttonLabel)
	_on_TextureButton_mouse_exited()
	if not enclosed:
		$Button/Label.visible = false
		$Button/Label.visible = true
		$Button/TextureButton.rect_position = $Button/Label.rect_position - Vector2(4, 0)
		$Button/TextureButton.rect_size = $Button/Label.rect_size + Vector2(8, 0)
	else:
		$Button/TextureButton.rect_position = Vector2(-79.5, -13)
		$Button/TextureButton.rect_size = Vector2(159, 27)

func colorize():
	var color = Utils.getBiomeColor()
	$Button/Back.modulate = color

func updateTranslations():
	setLabel(buttonLabel)

func setScale(value: int, adaptPos: bool = false):
	var oldScale = buttonScale
	buttonScale = value
	scale = Vector2(value, value)
	if adaptPos:
		position.y += (oldScale - value) * 12

func setLabel(value: int):
	buttonLabel = value
	if has_node("Button/Label"):
		$Button/Label.text = tr(Data.BUTTON_LABELS[value])
		if not enclosed:
			$Button/Label.visible = false
			$Button/Label.visible = true
			$Button/TextureButton.rect_position = $Button/Label.rect_position - Vector2(4, 0)
			$Button/TextureButton.rect_size = $Button/Label.rect_size + Vector2(8, 0)

func setEnclosed(value: bool):
	enclosed = value
	if has_node("Button/Label"):
		if not enclosed:
			$Button/Back.visible = false
			$Button/Label.visible = false
			$Button/Label.visible = true
			$Button/TextureButton.rect_position = $Button/Label.rect_position - Vector2(4, 0)
			$Button/TextureButton.rect_size = $Button/Label.rect_size + Vector2(8, 0)

func disable():
	$Button/TextureButton.visible = false
	$Button/Label.add_color_override("font_color", Colors.shade3 * Utils.getBiomeColor())

func enable():
	$Button/TextureButton.visible = true
	$Button/Label.remove_color_override("font_color")

func _on_TextureButton_pressed():
	emit_signal("pressed")

func _on_TextureButton_mouse_entered():
	$Button/Back.visible = enclosed
	$Button/Label.add_color_override("font_color", Colors.yellow)

func _on_TextureButton_mouse_exited():
	$Button/Back.visible = false
	$Button/Label.add_color_override("font_color", Colors.white)

func splash():
	$AnimationPlayer.play("Splash")
