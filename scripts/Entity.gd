extends Node2D
class_name Entity

var onBoard: bool = false
var pos: Vector2 = Vector2(0, 0)
var initPos: Vector2 = Vector2(0, 0)
var isDead = false
var barbarianToSlash: bool = false
var barbarianShouldReplay: bool = false
var thiefKilled: Node2D = null
var thiefShouldReplay: bool = false
var spiderShouldReplay: bool = false
var spiderToSlash: bool = false

func play(simulatedType: int, isFirst: bool = true, forceMonsterPlay: bool = false):
	if is_in_group("Monster") or forceMonsterPlay:
		playMonster(simulatedType)
	else:
		playHero(simulatedType)

func playHero(simaltedType: int):
	if isDead:
		return
	if not onBoard:
		return
	match simaltedType:
		Data.classes.Fighter:
			$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Slash, pos, true)
		Data.classes.Paladin:
			$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Slash, pos, true)
		Data.classes.Monk:
			$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Push, pos, true)
		Data.classes.Barbarian:
			if barbarianToSlash:
				$AnimationPlayer.play("Crumble")
				var e = Effect.launchAt(Data.effects.Slash, Data.DIR_UP, pos + Data.DIRECTIONS[Data.DIR_UP], true)
				if barbarianShouldReplay or Effect.isFatal(e):
					BattleHandler.toPlay.insert(0, Ref.turnOrder.getHeroSlot(self))
					thiefShouldReplay = true
				barbarianShouldReplay = false
				barbarianToSlash = false
			else:
				var e = Effect.launchAt(Data.effects.Push, Data.DIR_UP, pos, true)
				barbarianShouldReplay = Effect.isFatal(e)
				BattleHandler.toPlay.insert(0, Ref.turnOrder.getHeroSlot(self))
				barbarianToSlash = true
				thiefShouldReplay = true
		Data.classes.Wizard:
			Effect.launchOnLine(Data.effects.Fire, Data.DIR_LEFT, pos, true)
			Effect.launchOnLine(Data.effects.Fire, Data.DIR_RIGHT, pos, true)
		Data.classes.Thief:
			if not thiefShouldReplay:
				thiefKilled = null
				BattleHandler.currentThief = self
				$AnimationPlayer.play("Crumble")
				var e = Effect.launchAt(Data.effects.Slash, Data.DIR_RIGHT, pos + Vector2(0, 2), true)
				if Effect.isFatal(e):
					thiefShouldReplay = true
					BattleHandler.toPlay.insert(0, Ref.turnOrder.getHeroSlot(self))
				BattleHandler.currentThief = null
			elif thiefKilled != null:
				thiefShouldReplay = false
				if thiefKilled.is_in_group("Hero"):
					play(thiefKilled.type)
				elif thiefKilled.is_in_group("Monster"):
					play(thiefKilled.type, true, true)

func playMonster(simulatedType: int):
	match simulatedType:
		Data.monsters.Skeleton:
			if not $AnimationPlayer.current_animation == "Death":
				$AnimationPlayer.play("Crumble")
			Effect.launchAround(Data.effects.Slash, pos, true)
		Data.monsters.Spider:
			if spiderToSlash:
				$AnimationPlayer.play("Crumble")
				Effect.launchAt(Data.effects.Slash, Data.DIR_DOWN, pos + Vector2(0, 1), true)
				spiderShouldReplay = false
			else:
				Effect.launchAt(Data.effects.Push, Data.DIR_DOWN, pos, true)
				spiderToSlash = true
				spiderShouldReplay = true
				if is_in_group("Hero"):
					thiefShouldReplay = true
					BattleHandler.toPlay.insert(0, Ref.turnOrder.getHeroSlot(self))
