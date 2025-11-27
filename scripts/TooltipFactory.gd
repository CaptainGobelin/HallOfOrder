tool
extends Node2D
class_name TooltipFactory

enum tooltips {Fighter, Paladin, Monk, Wizard, Barbarian, Thief, 
	Goblin, Skeleton, Slime, Bat, Spider, Spikes, SwitchBlock, Lever,
	Teleporter, Tuto}

export(tooltips) var type = tooltips.Fighter setget setType
export(Vector2) var size = Vector2(3,3) setget setSize
export(bool) var isDisplayingTuto: bool = false

func _ready():
	Signals.connect("language_changed", self, "updateTranslations")
	for p in $Image/Puppets.get_children():
		p.visible = false
	updateTranslations()

func colorize():
	var color = Utils.getBiomeColor()
	for p in $Image/Puppets.get_children():
		p.colorize()
	$Image/Board.modulate = color
	$Image/Shadow.modulate = color

func updateTranslations():
	if isDisplayingTuto:
		$Labels/TopLabel.text = Data.getTutorial()

func setType(value: int):
	type = value
	if not has_node("Image"):
		return
	for p in $Image/Puppets.get_children():
		p.visible = false
	for e in $Image/Effects.get_children():
		e.stop()
	$AnimationPlayer.play("RESET")
	match type:
		tooltips.Fighter:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = tr("FIGHTER_BOT")
			setSize(Vector2(3, 3))
			$AnimationPlayer.play("Fighter")
		tooltips.Paladin:
			$Labels/TopLabel.text = tr("PALADIN_TOP")
			$Labels/BotLabel.text = tr("PALADIN_BOT")
			setSize(Vector2(4, 3))
			$AnimationPlayer.play("Paladin")
		tooltips.Monk:
			$Labels/TopLabel.text = tr("MONK_TOP")
			$Labels/BotLabel.text = tr("MONK_BOT")
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Monk")
		tooltips.Wizard:
			$Labels/TopLabel.text = tr("WIZARD_TOP")
			$Labels/BotLabel.text = tr("WIZARD_BOT")
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Wizard")
		tooltips.Barbarian:
			$Labels/TopLabel.text = tr("BARBARIAN_TOP")
			$Labels/BotLabel.text = tr("BARBARIAN_BOT")
			setSize(Vector2(3, 4))
			$AnimationPlayer.play("Barbarian")
		tooltips.Thief:
			$Labels/TopLabel.text = tr("THIEF_TOP")
			$Labels/BotLabel.text = tr("THIEF_BOT")
			setSize(Vector2(3, 4))
			$AnimationPlayer.play("Thief")
		tooltips.Goblin:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = tr("GOBLIN_BOT")
			setSize(Vector2(3, 3))
			$AnimationPlayer.play("Goblin")
		tooltips.Skeleton:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = tr("SKELETON_BOT")
			setSize(Vector2(3, 3))
			$AnimationPlayer.play("Skeleton")
		tooltips.Slime:
			$Labels/TopLabel.text = tr("SLIME_TOP")
			$Labels/BotLabel.text = tr("SLIME_BOT")
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Slime")
		tooltips.Bat:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = tr("BAT_BOT")
			setSize(Vector2(3, 3))
			$AnimationPlayer.play("Bat")
		tooltips.Spider:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = tr("SPIDER_BOT")
			setSize(Vector2(3, 4))
			$AnimationPlayer.play("Spider")
		tooltips.Spikes:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = tr("SPIKES_BOT")
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Spikes")
		tooltips.SwitchBlock:
			$Labels/TopLabel.text = tr("SWITCH_BLOCK_TOP")
			$Labels/BotLabel.text = tr("SWITCH_BLOCK_BOT")
			setSize(Vector2(5, 4))
			$AnimationPlayer.play("SwitchBlock")
		tooltips.Teleporter:
			$Labels/TopLabel.text = tr("TELEPORT_TOP")
			$Labels/BotLabel.text = tr("TELEPORT_BOT")
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Teleporter")
		tooltips.Lever:
			$Labels/BotLabel.text = ""
			$Labels/TopLabel.text = tr("LEVER_TOP")
			setSize(Vector2(0, 0))
			$AnimationPlayer.play("Tuto")
		tooltips.Tuto:
			$Labels/BotLabel.text = ""
			$Labels/TopLabel.text = Data.getTutorial()
			setSize(Vector2(0, 0))
			$AnimationPlayer.play("Tuto")

func setSize(value: Vector2):
	if value != size:
		size = value
		if not has_node("Image"):
			return
		$Image/Board.clear()
		for i in range(size.x):
			for j in range(size.y):
				$Image/Board.set_cell(i, j, 1)
		$Image/Shadow.clear()
		for i in range(size.x):
			for j in range(size.y):
				$Image/Shadow.set_cell(i, j, 0)
		$Image/Board. update_bitmask_region(Vector2(0,0), size)
		$Image/Shadow. update_bitmask_region(Vector2(0,0), size)
	$Labels/BotLabel.margin_top = 5 + (9 * size.y) / $Labels.scale.y
	$Labels.visible = false # To force update of labels rect
	$Labels.visible = true
	var pannelSize = (9 * size.y) + 6
	if not $Labels/BotLabel.text.empty():
		pannelSize += $Labels/BotLabel.rect_size.y * $Labels.scale.y
	if not $Labels/TopLabel.text.empty():
		pannelSize += $Labels/TopLabel.rect_size.y * $Labels.scale.y
	$Labels.position.x = 0
	$Image.position.x = -4.5 * size.x
	$Image.position.y = -pannelSize/2.0
	$Labels.position.y = -pannelSize/2.0
	if not $Labels/TopLabel.text.empty():
		$Image.position.y += $Labels/TopLabel.rect_size.y * $Labels.scale.y
		$Labels.position.y += $Labels/TopLabel.rect_size.y * $Labels.scale.y

func reset():
	$Image.visible = true
	for p in $Image/Puppets.get_children():
		p.reset()
