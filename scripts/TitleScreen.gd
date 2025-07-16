extends Node2D

func _ready():
	$AnimationPlayer.playback_speed = 0.65
	if ProfileData.firstLaunch:
		fadeIn()
		ProfileData.firstLaunch = false
	else:
		$AnimationPlayer.play("RESET")
	$VersionContainer/Label.text = tr("TITLE_VERSION") + ": v"
	$VersionContainer/Label.text += String(VersionControl.CURRENT_VERSION)
	$AuthorContainer/Label.text = tr("TITLE_GAME_BY") + " Jérémy Morel"
	var username = ProfileData.getLastUsername()
	if username == "":
		$MenuBlock/ProfileContainer.visible = false
		if ProfileData.getAllProfiles().empty():
			ProfileData.profileMode = ProfileData.PRO_CREATE
		else:
			ProfileData.profileMode = ProfileData.PRO_CHOOSE
		$MenuBlock/Buttons/PlayButton.visible = false
		$MenuBlock/Buttons/ProfileButton.setLabel(Data.LABEL_PLAY)
	else:
		ProfileData.profileMode = ProfileData.PRO_CHOOSE
		$MenuBlock/ProfileContainer.visible = true
		$MenuBlock/ProfileContainer/Label.text = tr("TITLE_PROFILE") + ": " + username

func fadeIn():
	$AnimationPlayer.play("FadeIn")

func fadeOut(scene: String):
	for b in $MenuBlock/Buttons.get_children():
		b.disable()
	$AnimationPlayer.play_backwards("FadeIn")
	$AnimationPlayer.connect("animation_finished", self, "goTo", [scene])

func goTo(_anim: String, scene: String):
	Utils.changeScene(scene)

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	fadeOut("res://scenes/LevelSelector.tscn")

func _on_ProfileButton_pressed():
	Utils.changeScene("res://scenes/ProfilePanel.tscn")

func _on_OptionsButton_pressed():
	Utils.changeScene("res://scenes/OptionsScreen.tscn")
