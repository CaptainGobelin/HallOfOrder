extends Node2D

var labelScene = preload("res://scenes/LabelButton.tscn")
var panelScene = preload("res://scenes/WorldPanel.tscn")

var currentPannel: int = 0

func _ready():
	var count = 0
	for w in Data.BIOMES.keys():
		var label = Utils.instanciate(labelScene, $Worlds)
		label.world = w
		label.connect("pressed", self, "switchPannel", [w])
		label.setScale(2)
		label.setEnclosed(false)
		if ProfileData.isUnlockedWorld(w):
			label.setLabel(Data.BIOMES[w][Data.BI_NAME])
		else:
			label.setLabel("?????")
			label.disable()
		label.position.y = 18
		label.position.x = (558.0/(Data.BIOMES.keys().size()-1)) * count + 81
		var panel = Utils.instanciate(panelScene, $Pannels)
		panel.visible = (w == currentPannel)
		panel.setWorld(w)
		count += 1
	if ProfileData.currentLevel.x != currentPannel:
		$Pannels.get_child(currentPannel).visible = false
		currentPannel = ProfileData.currentLevel.x
		$Pannels.get_child(currentPannel).get_node("AnimationPlayer").play("RESET")

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

func _on_LargeButton_pressed():
	Utils.changeScene("res://scenes/TitleScreen.tscn")
