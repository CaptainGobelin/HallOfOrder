extends Node2D

signal item_selected

var list = []

func _ready():
	$Labels.visible = false

func colorize():
	$Options.modulate = Utils.getBiomeColor()
	$Options.get_popup().modulate = Utils.getBiomeColor()

func addChoice(s: String):
	$Options.add_item("")
	var l = Label.new()
	l.theme = $Options.theme
	$Labels.add_child(l)
	l.margin_top = 13 * ($Labels.get_child_count() - 1)
	l.text = s
	list.append(s)

func getSelected() -> int:
	return $Options.selected

func select(index: int):
	$Label.text = list[index]
	$Options.selected = index

func disable():
	$Label.add_color_override("font_color", Colors.shade3 * Utils.getBiomeColor())
	$Options.disabled = true
	$Options.focus_mode = Control.FOCUS_NONE

func enable():
	$Label.remove_color_override("font_color")
	$Options.disabled = false
	$Options.focus_mode = Control.FOCUS_ALL

func _on_Options_toggled(button_pressed):
	$Labels.visible = button_pressed

func _on_Options_item_selected(index):
	$Label.text = list[index]
	emit_signal("item_selected")
