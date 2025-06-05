extends Node2D

func _ready():
	$AnimationPlayer.playback_speed = 0.35
	$Label.text = "The " + Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_NAME]
	VisualServer.set_default_clear_color(Colors.shade6 * Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_COLOR])

func _on_AnimationPlayer_animation_finished(anim_name):
	if (anim_name == "FadeIn"):
		$AnimationPlayer.play("FadeOut")
	else:
		Utils.changeScene("res://scenes/Game.tscn")
