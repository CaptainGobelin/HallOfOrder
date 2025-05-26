tool
extends Node2D

export (Data.effects) var type = Data.effects.Slash setget setType
export (Vector2) var pos = Vector2(0, 0) setget setPos
export (Data.dirs) var dir = Data.DIR_RIGHT setget setDir

var coords = 0 setget setCoord

func _ready():
	setType(type)
	$AnimationPlayer.playback_speed = Data.ANIM_SPEED
	$Sprite.visible = false

func setType(value):
	type = value
	setCoord(coords)
	setDir(dir)

func setCoord(value):
	coords = value
	if not has_node("Sprite"):
		return
	$Sprite.frame_coords = Vector2(value, type)

func setPos(value: Vector2):
	pos = value
	position = pos * 9

func setDir(value: int):
	dir = value
	if not has_node("Sprite"):
		return
	if not shouldFaceDirection():
		$Sprite.flip_h = false
		$Sprite.rotation_degrees = 0
		$Sprite.position.x = 0
		$Sprite.position.y = 0
		return
	match dir:
		Data.DIR_LEFT: 
			$Sprite.flip_h = true
			$Sprite.rotation_degrees = 0
			$Sprite.position.y = 0
			$Sprite.position.x = 0
		Data.DIR_UP:
			$Sprite.flip_h = false
			$Sprite.rotation_degrees = -90
			$Sprite.position.y = 9
			$Sprite.position.x = 0
		Data.DIR_DOWN:
			$Sprite.flip_h = false
			$Sprite.rotation_degrees = 90
			$Sprite.position.x = 9
			$Sprite.position.y = 0
		Data.DIR_RIGHT:
			$Sprite.flip_h = false
			$Sprite.rotation_degrees = 0
			$Sprite.position.x = 0
			$Sprite.position.y = 0

func shouldFaceDirection() -> bool:
	if type == Data.effects.Fire: return true
	return false

func play():
	$AnimationPlayer.play("Play")

func stop():
	$Sprite.visible = false
	$AnimationPlayer.stop()
