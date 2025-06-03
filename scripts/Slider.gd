tool
extends Node2D

signal valueChanged

export(int) var size = 4 setget setSize
export(PoolStringArray) var options = PoolStringArray(["Label 1", "Label 2"]) setget setOptions

func colorize():
	$HSlider.modulate = Utils.getBiomeColor()
	_on_HSlider_value_changed(int($HSlider.value))

func setSize(value: int):
	size = value
	if not has_node("HSlider"):
		return
	$HSlider.rect_size.x = 18 * size
	setOptions(options)

func setOptions(value: PoolStringArray):
	options = value
	if not has_node("HSlider"):
		return
	$HSlider.max_value = options.size() - 1
	$HSlider.tick_count = options.size()
	for l in $Labels.get_children():
		$Labels.remove_child(l)
		l.queue_free()
	var count = 0.0
	for o in options:
		var l = Label.new()
		l.theme = load("res://resources/little_theme.tres")
		l.align = Label.ALIGN_CENTER
		l.grow_horizontal = l.GROW_DIRECTION_BOTH
		l.text = o
		$Labels.add_child(l)
		l.rect_position.x = ((18 * float(size) / $Labels.scale.x) - (8 / $Labels.scale.x)) * (count / (float(options.size()) - 1))
		$Labels.visible = false
		$Labels.visible = true
		l.rect_position.x -= l.rect_size.x / 2
		count += 1.0

func _ready():
	setOptions(options)

func setValue(value: int):
	$HSlider.value = value
	_on_HSlider_value_changed(value)

func getValue() -> int:
	return $HSlider.value

func disable():
	for l in $Labels.get_children():
		l.add_color_override("font_color", Colors.shade4 * Utils.getBiomeColor())
	$HSlider.editable = false

func _on_HSlider_mouse_exited():
	$HSlider.release_focus()

func _on_HSlider_value_changed(_value):
	for l in $Labels.get_children():
		l.add_color_override("font_color", Colors.shade3 * Utils.getBiomeColor())
	$Labels.get_child(int($HSlider.value)).add_color_override("font_color", Colors.white)
	emit_signal("valueChanged")
