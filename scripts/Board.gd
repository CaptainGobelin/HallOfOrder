extends TileMap
class_name Board

func _ready():
	Ref.board = self
	disableButton()

func enableButton():
	$TextureButton.disabled = false

func disableButton():
	$TextureButton.disabled = true

func _on_TextureButton_pressed():
	if $TextureButton.disabled:
		return
	var mousePos = get_local_mouse_position() / Data.CELL_SIZE
	mousePos.x = int(mousePos.x - 1)
	mousePos.y = int(mousePos.y - 1)
	MouseHandler.placeHero(mousePos)

static func isCellTaken(cell: Vector2) -> bool:
	for m in Ref.monsters.get_children():
		if m.pos == cell:
			return true
	for s in Ref.sceneries.get_children():
		if s.isIgnored():
			continue
		if s.pos == cell:
			return true
	return false

static func getCellEntity(cell: Vector2) -> Node:
	for h in Ref.heroes.get_children():
		if h.isDead:
			continue
		if not h.onBoard:
			continue
		if h.pos == cell:
			return h
	for m in Ref.monsters.get_children():
		if m.isDead:
			continue
		if m.pos == cell:
			return m
	for s in Ref.sceneries.get_children():
		if s.isIgnored():
			continue
		if s.pos == cell:
			return s
	return null

static func getCellScenery(cell: Vector2) -> Node:
	for s in Ref.sceneries.get_children():
		if s.pos == cell:
			return s
	return null

static func getAllEntities(skipDeads: bool = false) -> Array:
	var result = []
	for h in Ref.heroes.get_children():
		if h.isDead and skipDeads:
			continue
		if not h.onBoard:
			continue
		result.append(h)
	for m in Ref.monsters.get_children():
		if m.isDead and skipDeads:
			continue
		result.append(m)
	for s in Ref.sceneries.get_children():
		result.append(s)
	return result

static func isOOB(cell: Vector2) -> bool:
	if cell.x < 0 or cell.y < 0:
		return true
	if cell.x >= Data.BOARD_X or cell.y >= Data.BOARD_Y:
		return true
	return false

static func isBlocked(cell: Vector2) -> bool:
	if isOOB(cell):
		return true
	var e = getCellScenery(cell)
	if e == null:
		return false
	if e.isBlocking():
		return true
	return false
