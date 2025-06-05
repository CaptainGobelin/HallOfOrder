extends Node2D

func _ready():
	if ProfileData.introPlayed.has(int(ProfileData.currentLevel.x)):
		Utils.changeScene("res://scenes/Game.tscn")
	else:
		ProfileData.introPlayed.append(int(ProfileData.currentLevel.x))
	$AnimationPlayer.playback_speed = 0.35
	$Label.text = "The " + Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_NAME]
	$AnimationPlayer.play("FadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "FadeIn"):
		VisualServer.set_default_clear_color(Colors.shade6 * Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_COLOR])
		$AnimationPlayer.play("FadeOut")
	else:
		Utils.changeScene("res://scenes/Game.tscn")
