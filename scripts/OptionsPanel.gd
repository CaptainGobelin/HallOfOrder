extends Node2D

signal exit

var screenOptions: PoolVector2Array

func _ready():
	screenOptions = OptionsHandler.getResolutionOptions()
	var i = 0
	for r in screenOptions:
		$Graphics/ScreenSizeOption.add_item(vectorToStr(r), i)
		if r == ProfileData.screenSize:
			$Graphics/ScreenSizeOption.select(i)
		i += 1
	for _i in range(5):
		$Language/LanguageOption.add_item("English")
	loadOptions()

func loadOptions():
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
	ProfileData.screenSize = screenOptions[$Graphics/ScreenSizeOption.selected]
	Signals.fullscreenChanged()
	Signals.screenSizeChanged()

func _on_FullscreenSlider_valueChanged():
	if $Graphics/FullscreenSlider.getValue() == 1:
		$Graphics/ScreenSizeLabel.add_color_override("font_color", Colors.shade3)
		$Graphics/ScreenSizeOption.disabled = true
		$Graphics/ScreenSizeOption.focus_mode = Control.FOCUS_NONE
	else:
		$Graphics/ScreenSizeLabel.add_color_override("font_color", Colors.white)
		$Graphics/ScreenSizeOption.disabled = false
		$Graphics/ScreenSizeOption.focus_mode = Control.FOCUS_ALL
