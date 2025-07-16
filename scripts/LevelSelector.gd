extends Node2D

var labelScene = preload("res://scenes/LabelButton.tscn")
var panelScene = preload("res://scenes/WorldPanel.tscn")

var currentPannel: int = 0

func _ready():
	Signals.connect("language_changed", self, "updateTranslations")
	updateTranslations()
	var count = 0
	for w in Data.BIOMES.keys():
		var label = Utils.instanciate(labelScene, $Worlds)
		label.world = w
		label.connect("pressed", self, "switchPannel", [w])
		label.setScale(2)
		label.setEnclosed(false)
		if ProfileData.isUnlockedWorld(w):
			label.setLabel(Data.LABEL_BIOME + w)
		else:
			label.setLabel(Data.LABEL_UNKNOWN)
			label.disable()
		label.position.y = 18
		label.position.x = (558.0/(Data.BIOMES.keys().size()-1)) * count + 81
		var panel = Utils.instanciate(panelScene, $Pannels)
		panel.visible = (w == currentPannel)
		panel.setWorld(w)
		panel.connect("pressed", self, "selectLevel")
		count += 1
	if ProfileData.currentLevel.x != currentPannel:
		$Pannels.get_child(currentPannel).visible = false
		currentPannel = int(ProfileData.currentLevel.x)
		$Pannels.get_child(currentPannel).get_node("AnimationPlayer").play("RESET")

func updateTranslations():
	$Title/Label.text = tr("LEVELS_TITLE")

func switchPannel(next: int):
	if next == currentPannel:
		return
	if next > currentPannel:
		$Pannels.get_child(currentPannel).get_node("AnimationPlayer").play("FadeLeft")
		$Pannels.get_child(next).get_node("AnimationPlayer").play_backwards("FadeRight")
	else:
		$Pannels.get_child(currentPannel).get_node("AnimationPlayer").play("FadeRight")
		$Pannels.get_child(next).get_node("AnimationPlayer").play_backwards("FadeLeft")
	currentPannel = next

func selectLevel(w: Node2D):
	var p = w.global_position + Vector2(63, 54)
	$Title.position -= p
	$Worlds.position -= p
	$TileMap.position -= p
	$LargeButton.position -= p
	$Pannels.position -= p
	position += p
	$AnimationPlayer.play("FadeOut")

func _on_LargeButton_pressed():
	Utils.changeScene("res://scenes/TitleScreen.tscn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		Utils.changeScene("res://scenes/TransitionScreen.tscn")
