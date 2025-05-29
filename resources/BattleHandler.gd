extends Node

var toPlay: Array = []

func _ready():
	Signals.connect("change_scene", self, "resetScene")

func resetScene():
	toPlay = []

func playBattle():
	toPlay = range(Ref.turnOrder.size)
	playNext()

func playNext():
	if toPlay.empty():
		if checkWin():
			Ref.game.nextLevel()
		else:
			stopBattle()
		return
	var slot = toPlay.pop_front()
	var turn = Ref.turnOrder.getSpace(slot)
	if turn == null:
		return
	if turn.isEmpty:
		playNext()
		return
	Waiter.flush()
	if turn.contained is Hero:
		turn.contained.play()
	elif turn.contained is Monster:
		Monster.playAll(turn.contained.type)
	endTurnEvents()
	if not Waiter.isEmpty():
		if ProfileData.animSpeed == ProfileData.ANIM_NORMAL:
			Waiter.add(CustomTimer.trigger(1.0))
	Waiter.wait(funcref(self, "playNext"))

func endTurnEvents():
	for m in Ref.monsters.get_children():
		if m.isDying:
			m.isDead = true
			m.isDying = false

func stopBattle():
	toPlay = []
	Effect.killAll()
	Waiter.flush()
	for e in Board.getAllEntities():
		if e is Hero:
			e.reset()
		if e is Monster:
			e.reset()
	ButtonHandler.normalMode()

func checkWin() -> bool:
	for m in Ref.monsters.get_children():
		if not m.isDead:
			return false
	return true
