extends Node

var stack: Array  = []

func _ready():
	Signals.connect("change_scene", self, "resetScene")

func resetScene():
	flush()

func flush():
	stack = []

func wait(callback: FuncRef, args: Array = []):
	for s in stack:
		if s == null:
			continue
		if not is_instance_valid(s):
			continue
		if s is GDScriptFunctionState:
			if s.is_valid():
				yield(s, "completed")
	if callback.is_valid():
		if args.size() == 0:
			callback.call_func()
		else:
			callback.call_funcv(args)

func add(s):
	stack.append(s)

func isEmpty() -> bool:
	for s in stack:
		if s == null:
			continue
		if not is_instance_valid(s):
			continue
		if s is GDScriptFunctionState:
			return false
	return true
