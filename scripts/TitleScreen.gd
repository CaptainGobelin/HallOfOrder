extends Node2D

const profilePrefix = "Profile: "

func _ready():
	$VersionContainer/Label.text = "Current version: v"
	$VersionContainer/Label.text += String(VersionControl.CURRENT_VERSION)
	var username = ProfileData.getLastUsername()
	if username == "":
		$ProfileContainer.visible = false
		if ProfileData.getAllProfiles().empty():
			ProfileData.profileMode = ProfileData.PRO_CREATE
		else:
			ProfileData.profileMode = ProfileData.PRO_CHOOSE
		$Buttons/PlayButton.visible = false
		$Buttons/ProfileButton.setLabel("Play")
	else:
		ProfileData.profileMode = ProfileData.PRO_CHOOSE
		$ProfileContainer.visible = true
		$ProfileContainer/Label.text = profilePrefix + username

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_PlayButton_pressed():
	Utils.changeScene("res://scenes/LevelSelector.tscn")

func _on_ProfileButton_pressed():
	Utils.changeScene("res://scenes/ProfilePanel.tscn")
