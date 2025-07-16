extends Node2D

var row = preload("res://scenes/ProfileRow.tscn")

var rowStarter: int = 0
var maxElements: int = 0
var currentFocus = null
var toDelete = null

func _ready():
	updateTranslations()
	position = Vector2(165, 99)
	$TitleBackground.position = -Vector2(165, 99)/2
	$Help/MenuBlock/Path.text = OS.get_user_data_dir()
	fillData(ProfileData.getAllProfiles())
	unfocus()
	if ProfileData.profileMode == ProfileData.PRO_CREATE:
		_on_CreateButton_pressed()
	else:
		$Choose.visible = true
		$Create.visible = false
		$Delete.visible = false
		unfocus()

func _input(event):
	if event.is_action_pressed("ui_page_up"):
		if rowStarter == 0:
			return
		rowStarter -= 1
		for r in $Choose/Table/Rows.get_children():
			r.setStarter(rowStarter, rowStarter + 6)
			$Choose/Table/MenuScroller.setArrows(rowStarter, maxElements)
			$Choose/Table/TextureButton.visible = $Choose/Table/MenuScroller.isActive
	elif event.is_action_pressed("ui_page_down"):
		if rowStarter > maxElements - 7:
			return
		rowStarter += 1
		for r in $Choose/Table/Rows.get_children():
			r.setStarter(rowStarter, rowStarter + 6)
			$Choose/Table/MenuScroller.setArrows(rowStarter, maxElements)
			$Choose/Table/TextureButton.visible = $Choose/Table/MenuScroller.isActive

func updateTranslations():
	$Choose/Title.text = tr("TITLE_BUTTON_PROFILE")
	$Choose/Table/Header/NameHeader/Label.text = tr("PROFILE_NAME")
	$Choose/Table/Header/ProgressHeader/Label.text = tr("PROFILE_PROGRESS")
	$Create/Label.text = tr("PROFILE_NAME_WINDOW")
	$Create/LineEdit.placeholder_text = tr("PROFILE_NAME")
	$Delete/MenuBlock/Label.text = tr("PROFILE_DELETE_WINDOW")
	$Help/MenuBlock/Label.text = tr("PROFILE_HELP_WINDOW")

func fillData(profiles: Array):
	for r in $Choose/Table/Rows.get_children():
		$Choose/Table/Rows.remove_child(r)
		r.queue_free()
	rowStarter = 0
	if profiles.empty():
		$Choose/Table.visible = false
		$Choose/NoProfile.visible = true
	else:
		$Choose/Table.visible = true
		$Choose/NoProfile.visible = false
		var count = 0
		for p in profiles:
			var r = Utils.instanciate(row, $Choose/Table/Rows)
			r.setPosition(count)
			r.setStarter(rowStarter, rowStarter + 6)
			r.setData(p[0], p[1], p[2])
			r.connect("focus", self, "focus", [r])
			r.connect("unfocus", self, "unfocus")
			count += 1
		if ($Choose/Table/Rows.get_child_count() <= 6):
			maxElements = $Choose/Table/Rows.get_child_count()
		else:
			maxElements = $Choose/Table/Rows.get_child_count() + 3
	$Choose/Table/MenuScroller.setArrows(rowStarter, maxElements)
	$Choose/Table/TextureButton.visible = $Choose/Table/MenuScroller.isActive

func focus(node):
	currentFocus = node
	$Choose/DeleteButton.enable()
	$Choose/SelectButton.enable()

func unfocus():
	currentFocus = null
	$Choose/DeleteButton.disable()
	$Choose/SelectButton.disable()

func _on_TextureButton_mouse_entered():
	set_process_input(true and $Choose/Table/MenuScroller.isActive)

func _on_TextureButton_mouse_exited():
	set_process_input(false and $Choose/Table/MenuScroller.isActive)

func _on_CreateButton_pressed():
	$Choose.visible = false
	unfocus()
	$Create.visible = true

func _on_SelectButton_pressed():
	if currentFocus == null:
		return
	if not ProfileData.loadProfile(currentFocus.saveFile):
		return
	ProfileData.skipGamemode = true
	ProfileData.lastProfile = ProfileData.saveFilename
	ProfileData.saveSettings()
	Utils.changeScene("res://scenes/LevelSelector.tscn")

func _on_DeleteButton_pressed():
	if currentFocus == null:
		return
	toDelete = currentFocus
	$Delete/MenuBlock/Profile.text = toDelete.getName()
	$Choose.visible = false
	$Delete.visible = true

func _on_CancelButton_pressed():
	if ProfileData.profileMode == ProfileData.PRO_CREATE:
		Utils.changeScene("res://scenes/TitleScreen.tscn")
		return
	$Choose.visible = true
	$Create.visible = false
	unfocus()

func _on_CancelDeleteButton_pressed():
	$Choose.visible = true
	$Delete.visible = false
	unfocus()

func _on_ConfirmCreateButton_pressed():
	ProfileData.createProfile($Create/LineEdit.text)
	if ProfileData.profileMode == ProfileData.PRO_CREATE:
		ProfileData.skipGamemode = true
		ProfileData.lastProfile = ProfileData.saveFilename
		ProfileData.saveSettings()
		Utils.changeScene("res://scenes/LevelSelector.tscn")
	else:
		fillData(ProfileData.getAllProfiles())
		_on_CancelButton_pressed()

func _on_LineEdit_text_changed(new_text):
	if new_text.empty():
		$Create/ConfirmCreateButton.disable()
	else:
		$Create/ConfirmCreateButton.enable()

func _on_LineEdit_visibility_changed():
	if $Create/LineEdit.visible:
		$Create/LineEdit.text = ""
		$Create/ConfirmCreateButton.disable()
		$Create/LineEdit.grab_focus()

func _on_CloseButton_pressed():
	Utils.changeScene("res://scenes/TitleScreen.tscn")

func _on_ConfirmDeleteButton_pressed():
	ProfileData.delete(toDelete.saveFile)
	if ProfileData.lastProfile == toDelete.saveFile:
		ProfileData.lastProfile = ""
		ProfileData.saveFilename = ""
		ProfileData.saveSettings()
	fillData(ProfileData.getAllProfiles())
	_on_CancelDeleteButton_pressed()

func _on_CopyButton_pressed():
	OS.set_clipboard(OS.get_user_data_dir())

func _on_ConfirmHelpButton_pressed():
	$Choose.visible = true
	$Help.visible = false

func _on_HelpButton_pressed():
	$Choose.visible = false
	$Help.visible = true
	unfocus()
