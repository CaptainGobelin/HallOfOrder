tool
extends Node2D

signal pressed

export(bool) var isHandled = true
export(ButtonHandler.Icons) var buttonIcon = ButtonHandler.Icons.Sound setget setIcon

func _ready():
	setIcon(buttonIcon)
	if isHandled:
		connect("pressed", ButtonHandler, "buttonPressed", [buttonIcon])
		ButtonHandler.register(self, ButtonHandler.Types.Menu)

func setIcon(value: int):
	buttonIcon = value
	if not has_node("Icon"):
		return
	$Icon.frame = value

func _on_TextureButton_mouse_entered():
	$Icon.frame = buttonIcon - 6
	Signals.buttonHovered(buttonIcon)

func _on_TextureButton_mouse_exited():
	$Icon.frame = buttonIcon
	Signals.buttonUnhovered()

func _on_TextureButton_pressed():
	emit_signal("pressed")

func disable():
	$TextureButton.disabled = true

func enable():
	$TextureButton.disabled = false
