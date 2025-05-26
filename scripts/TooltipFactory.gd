tool
extends Node2D
class_name TooltipFactory

enum tooltips {Fighter, Paladin, Monk, Wizard, Spikes}

export(tooltips) var type = tooltips.Fighter setget setType
export(Vector2) var size = Vector2(3,3) setget setSize

func _ready():
	for p in $Image/Puppets.get_children():
		p.visible = false

func colorize():
	var color = Utils.getBiomeColor()
	for p in $Image/Puppets.get_children():
		p.colorize()
	$Image/Board.modulate = color
	$Image/Shadow.modulate = color

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
			$Labels/BotLabel.text = "The fighter hits all cells around him."
			setSize(Vector2(3, 3))
			$AnimationPlayer.play("Fighter")
		tooltips.Paladin:
			$Labels/TopLabel.text = "The paladin hits all cells around him."
			$Labels/BotLabel.text = "The paladin cannot die from any attack."
			setSize(Vector2(4, 3))
			$AnimationPlayer.play("Paladin")
		tooltips.Monk:
			$Labels/TopLabel.text = "The pushes all creatures around him."
			$Labels/BotLabel.text = "Creatures will die if pushed against a wall."
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Monk")
		tooltips.Wizard:
			$Labels/TopLabel.text = "Wizard burns all creatures on his line."
			$Labels/BotLabel.text = "The fire is blocked by walls."
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Wizard")
		tooltips.Spikes:
			$Labels/TopLabel.text = ""
			$Labels/BotLabel.text = "The spike trap kills any creature that stand on it."
			setSize(Vector2(5, 3))
			$AnimationPlayer.play("Spikes")

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
	$Labels.visible = false
	yield(get_tree(), "idle_frame")
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
	for p in $Image/Puppets.get_children():
		p.reset()
