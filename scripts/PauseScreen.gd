extends Node2D

func _ready():
	visible = false

func _on_OptionsPanel_exit():
	$OptionsPanel.visible = false
	$Buttons.visible = true

func _on_OptionsButton_pressed():
	$OptionsPanel.visible = true
	$Buttons.visible = false
	$Buttons/OptionsButton._on_TextureButton_mouse_exited()

func _on_LevelButton_pressed():
	Utils.changeScene("res://scenes/LevelSelector.tscn")

func _on_ResumeButton_pressed():
	visible = false
	$Buttons/ResumeButton._on_TextureButton_mouse_exited()

func _on_MenuButton_pressed():
	Utils.changeScene("res://scenes/TitleScreen.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
