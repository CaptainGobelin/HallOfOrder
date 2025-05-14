extends Node

var game: Game
var ui: Ui
var turnOrder: TurnOrder
var monsters: Node2D
var heroes: Node2D
var sceneries: Node2D
var utils: Node2D
var board: Board

func _ready():
	Signals.connect("change_scene", self, "resetScene")

func resetScene():
	game = null
	ui = null
	turnOrder = null
	monsters = null
	heroes = null
	sceneries = null
	utils = null
	board = null
