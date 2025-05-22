extends Node2D

signal focus
signal unfocus

var pos: int = 0
var saveFile: String

func _ready():
	$Back.visible = false
	$Focus.visible = false
	$Back.color = Colors.shade5
	$Focus.color = Colors.shade4

func getName() -> String:
	return $Name.text

func setData(name: String, progress: int, file: String):
	$Name.text = name
	$Progress.text = String(progress) + "%"
	saveFile = file

func setPosition(newPos: int):
	pos = newPos

func setStarter(starter: int, ender: int):
	if pos >= ender or pos < starter:
		visible = false
	else:
		visible = true
		position.y = (pos - starter) * 20

func _on_TextureButton_mouse_entered():
	$Back.visible = true

func _on_TextureButton_mouse_exited():
	$Back.visible = false

func _on_TextureButton_focus_entered():
	$Focus.visible = true
	emit_signal("focus")

func _on_TextureButton_focus_exited():
	$Focus.visible = false
	emit_signal("unfocus")
