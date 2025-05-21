extends Node

#TODO indentation
func dict_to_string(dict: Dictionary) -> String:
	var result: String = "{"
	for k in dict.keys():
		result += thing_to_string(String(k)) + ": " + thing_to_string(dict[k]) + ", "
	return result + "}"

func thing_to_string(t) -> String:
	if t is Dictionary:
		return dict_to_string(t)
	if t is String:
		return '"' + t + '"'
	if t is Vector2:
		return "Vector2(" + thing_to_string(t.x) + ", " + thing_to_string(t.y) + ")"
	if t is Array:
		var i = 0
		var result = "["
		for e in t:
			if i > 0:
				result += ", "
			result += thing_to_string(e)
			i += 1
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
	return Data.BIOMES[int(ProfileData.currentLevel.x)][Data.BI_COLOR]
