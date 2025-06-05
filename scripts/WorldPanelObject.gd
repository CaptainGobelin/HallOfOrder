extends Node2D

onready var heroScene = preload("res://scenes/WorldPanelObjectHero.tscn")
onready var monsterScene = preload("res://scenes/WorldPanelObjectMonster.tscn")

signal pressed

var world: int
var level: int

func init(w: int, l: int):
	world = w
	level = l
	flush()
	loadData()

func addHero(type: int):
	var hero = Utils.instanciate(heroScene, $Heroes)
	hero.setType(type)
	hero.position.x = ($Heroes.get_child_count() - 1) * 6
	$Heroes.position.x -= 3

func addMonster(pos: Vector2, isScenery: bool = false):
	var monster = Utils.instanciate(monsterScene, $Monsters)
	monster.setType(isScenery)
	monster.position = pos * 4

func flush():
	$Heroes.position.x = 31.5
	for h in $Heroes.get_children():
		$Heroes.remove_child(h)
		h.queue_free()
	for m in $Monsters.get_children():
		$Monsters.remove_child(m)
		m.queue_free()

func loadData():
	if not LevelLoader.levels.has(String(world) + "_" + String(level)):
		$TextureButton.disabled = true
	elif not ProfileData.isUnlockedLevel(world, level):
		$TextureButton.disabled = true
	else:
		var lvl = LevelLoader.levels[String(world) + "_" + String(level)]
		for h in lvl[LevelLoader.HEROES]:
			addHero(h[LevelLoader.TYPE])
		for m in lvl[LevelLoader.MONSTERS]:
			addMonster(m[LevelLoader.POSITION])
		for s in lvl[LevelLoader.SCENERIES]:
			addMonster(s[LevelLoader.POSITION], true)
		$Cup.visible = ProfileData.isDoneLevel(world, level)
	$Label.text = Utils.toRoman(level + 1)
	setColor()

func setColor():
	$TextureButton.modulate = Data.BIOMES[world][Data.BI_COLOR]
	for h in $Heroes.get_children():
		h.setColor(world)
	for m in $Monsters.get_children():
		m.setColor(world)

func _on_TextureButton_pressed():
	ProfileData.currentLevel = Vector2(world, level)
	ProfileData.skipGamemode = true
	Utils.changeScene("res://scenes/TransitionScreen.tscn")

func _on_TextureButton_mouse_entered():
	for h in $Heroes.get_children():
		h.hover()
	for m in $Monsters.get_children():
		m.hover()

func _on_TextureButton_mouse_exited():
	for h in $Heroes.get_children():
		h.unhover()
	for m in $Monsters.get_children():
		m.unhover()
