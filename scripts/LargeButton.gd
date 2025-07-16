tool
extends Node2D

signal pressed
const TXT_POS = 3.5
const ICON_POS = 0

export(bool) var isHandled = true
export(int) var buttonScale = 3 setget setScale
export(Data.LargeButtonLabels) var buttonLabel = Data.LargeButtonLabels.Play setget setLabel
export(ButtonHandler.Icons) var buttonIcon = ButtonHandler.Icons.Play setget setIcon

func _ready():
	Signals.connect("language_changed", self, "updateTranslations")
	$TextContainer.position.y = TXT_POS
	$Icon.position.y = ICON_POS
	if isHandled:
		connect("pressed", ButtonHandler, "buttonPressed", [buttonIcon])
		ButtonHandler.register(self, ButtonHandler.Types.Menu)
	updateTranslations()

func updateTranslations():
	setLabel(buttonLabel)

func setScale(value: int):
	buttonScale = value
	scale = Vector2(value, value)

func setLabel(value: int):
	buttonLabel = value
	if has_node("TextContainer"):
		$TextContainer/Label.text = tr(Data.BUTTON_LABELS[value])

func setIcon(value: int):
	buttonIcon = value
	if has_node("Icon"):
		$Icon.frame = value

func _on_TextureButton_button_down():
	$TextContainer.position.y = TXT_POS + 1
	$Icon.position.y = ICON_POS + 1

func _on_TextureButton_button_up():
	$TextContainer.position.y = TXT_POS
	$Icon.position.y = ICON_POS

func _on_TextureButton_pressed():
	emit_signal("pressed")

func disable():
	$TextureButton.disabled = true

func enable():
	$TextureButton.disabled = false
