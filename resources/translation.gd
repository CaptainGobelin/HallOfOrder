extends Node

func _ready():
	TranslationServer.set_locale("en")

func changeLanguage():
	TranslationServer.set_locale(TranslationServer.get_loaded_locales()[ProfileData.language])
	Signals.languageChanged()
