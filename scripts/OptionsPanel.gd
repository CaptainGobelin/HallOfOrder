extends Node2D

signal exit

var screenOptions: PoolVector2Array

func _ready():
	screenOptions = OptionsHandler.getResolutionOptions()
	var i = 0
	for r in screenOptions:
		$Graphics/ScreenSizeChoice.addChoice(vectorToStr(r))
		if r == ProfileData.screenSize:
			$Graphics/ScreenSizeChoice.select(i)
		i += 1
	$Language/LanguageChoice.addChoice("English")
	$Language/LanguageChoice.select(0)
	loadOptions()
	#TODO remove when implemented
	$Gameplay/DragSlider.disable()
	$Gameplay/DragLabel.add_color_override("font_color", Colors.shade4 * Utils.getBiomeColor())

func colorize():
	var color = Utils.getBiomeColor()
	$MenuBlock.colorize()
	$BackButton.colorize()
	$Language.colorize()
	$Language/LanguageChoice.colorize()
	$Graphics.colorize()
	$Graphics/ApplyButton.colorize()
	$Graphics/ScreenSizeChoice.colorize()
	$Graphics/FullscreenSlider.colorize()
	$Gameplay.colorize()
	$Gameplay/CursorSlider.colorize()
	$Gameplay/AnimSpeedSlider.colorize()
	$Gameplay/DragSlider.colorize()
	$Sounds.colorize()
	$Sounds/MusicSlider.modulate = color
	$Sounds/SoundsSlider.modulate = color
	$Graphics/BrightnessSlider.modulate = color
	#TODO remove when implemented
	$Gameplay/DragSlider.disable()
	$Gameplay/DragLabel.add_color_override("font_color", Colors.shade4 * Utils.getBiomeColor())

func loadOptions():
	$Gameplay/CursorSlider.setValue(ProfileData.cursorSize)
	$Gameplay/AnimSpeedSlider.setValue(ProfileData.animSpeed)
	$Graphics/BrightnessSlider.value = (ProfileData.brightness - 0.2) * 10.0
	$Graphics/FullscreenSlider.setValue(int(ProfileData.fullscreen))

func saveOptions():
	ProfileData.fullscreen = $Graphics/FullscreenSlider.getValue()
	if ProfileData.saveSettings():
		Signals.allSettings()
	else:
		pass #TODO what do we do if we fail to save settings?

func vectorToStr(v: Vector2) -> String:
	return String(int(v.x)) + "x" + String(int(v.y))

func _on_BackButton_pressed():
	saveOptions()
	emit_signal("exit")

func _on_ApplyButton_pressed():
	ProfileData.fullscreen = $Graphics/FullscreenSlider.getValue() == 1
	ProfileData.screenSize = screenOptions[$Graphics/ScreenSizeChoice.getSelected()]
	Signals.fullscreenChanged()
	Signals.screenSizeChanged()
	ProfileData.saveSettings()

func _on_FullscreenSlider_valueChanged():
	if $Graphics/FullscreenSlider.getValue() == 1:
		$Graphics/ScreenSizeLabel.add_color_override("font_color", Colors.shade3)
		$Graphics/ScreenSizeLabel.modulate = Utils.getBiomeColor()
		$Graphics/ScreenSizeChoice.disable()
	else:
		$Graphics/ScreenSizeLabel.add_color_override("font_color", Colors.white)
		$Graphics/ScreenSizeLabel.modulate = Color.white
		$Graphics/ScreenSizeChoice.enable()

func _on_CursorSlider_valueChanged():
	if $Gameplay/CursorSlider.getValue() == 0:
		ProfileData.cursorSize = ProfileData.CURSOR_S
	elif $Gameplay/CursorSlider.getValue() == 1:
		ProfileData.cursorSize = ProfileData.CURSOR_M
	else:
		ProfileData.cursorSize = ProfileData.CURSOR_L
	Signals.cursorSizeChanged()

func _on_AnimSpeedSlider_valueChanged():
	if $Gameplay/AnimSpeedSlider.getValue() == 0:
		ProfileData.animSpeed = ProfileData.ANIM_NORMAL
	else:
		ProfileData.animSpeed = ProfileData.ANIM_FAST

func _on_BrightnessSlider_value_changed(value):
	ProfileData.brightness = (value / 10.0) + 0.2
	Signals.brightnessChanged()
