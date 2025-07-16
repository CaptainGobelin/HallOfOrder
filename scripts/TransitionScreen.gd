extends Node2D

func _ready():
	Signals.connect("language_changed", self, "updateTranslations")
	if ProfileData.introPlayed.has(int(ProfileData.currentLevel.x)):
		Utils.changeScene("res://scenes/Game.tscn")
	else:
		ProfileData.introPlayed.append(int(ProfileData.currentLevel.x))
	$AnimationPlayer.playback_speed = 0.35
	updateTranslations()
	$AnimationPlayer.play("FadeIn")

func updateTranslations():
	$Label.text = tr(Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_TRANSITION])

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "FadeIn"):
		VisualServer.set_default_clear_color(Colors.shade6 * Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_COLOR])
		$AnimationPlayer.play("FadeOut")
	else:
		Utils.changeScene("res://scenes/Game.tscn")
