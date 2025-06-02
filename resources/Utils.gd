extends Node

#TODO indentation
func dict_to_string(dict: Dictionary, tabs: int = 0) -> String:
	var result: String = "{\n"
	for k in dict.keys():
		for _t in range(tabs + 1):
			result += '\t'
		result += thing_to_string(String(k), 0) + ": " + thing_to_string(dict[k], tabs+1) + ",\n"
	for _t in range(tabs):
		result += '\t'
	return result + "}"

func thing_to_string(t, tabs: int) -> String:
	if t is Dictionary:
		return dict_to_string(t, tabs)
	if t is String:
		return '"' + t + '"'
	if t is Vector2:
		return "Vector2(" + thing_to_string(t.x, 0) + ", " + thing_to_string(t.y, 0) + ")"
	if t is Array:
		if t.empty():
			return "[]"
		var i = 0
		var result = "["
		for e in t:
			if i > 0:
				if e is Dictionary:
					result += ", "
				else:
					result += ",\n"
			else:
				if not e is Dictionary:
					result += '\n'
			if not e is Dictionary:
				for _t in range(tabs+1):
					result += '\t'
			result += thing_to_string(e, tabs+1)
			i += 1
		result += "\n"
		for _t in range(tabs):
			result += '\t'
		return result + "]"
	return String(t)

static func instanciate(scene: PackedScene, parent: Node) -> Node:
	var instance = scene.instance()
	parent.add_child(instance)
	return instance

static func createFake(scene: PackedScene) -> Node:
	var instance = scene.instance()
	return instance

func changeScene(path: String):
	Signals.changeSceneSignal()
	get_tree().change_scene(path)

static func toRoman(number: int) -> String:
	var result = ""
	while number > 9:
		result += "X"
		number -= 10
	match number:
		1:
			result += "I"
		2:
			result += "II"
		3:
			result += "III"
		4:
			result += "IV"
		5:
			result += "V"
		6:
			result += "VI"
		7:
			result += "VII"
		8:
			result += "VIII"
		9:
			result += "IX"
	return result

static func strToFilename(s: String) -> String:
	var result = (s + Time.get_datetime_string_from_system()).sha1_text()
	return result.substr(0, 10)

static func getBiomeColor() -> Color:
	if Ref.game == null:
		return Color.white
	return Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_COLOR]
