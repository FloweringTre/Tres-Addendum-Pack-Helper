extends Control

@onready var location_text: LineEdit = $NinePatchRect/VBoxContainer/Hbox/locationText
@onready var folder_nametext: LineEdit = $NinePatchRect/VBoxContainer/Hbox2/folderNametext

var old_pack : bool
signal setup_done
var root_changed : bool
var folder_changed : bool
var directory : String

func _ready() -> void:
	if GlobalScripts.root != "":
		location_text.text = GlobalScripts.root
		root_changed = true
		old_pack = true
		on_done()
	else:
		location_text.text = GlobalScripts.directory_root
		$NinePatchRect/VBoxContainer/Stage1BoxContainer.visible = true
		$NinePatchRect/VBoxContainer/Stage2BoxContainer.visible = false
		%confirmButton.visible = true
		%newpackButton.visible = false
	if GlobalScripts.folder != "":
		folder_nametext.text = GlobalScripts.folder
		old_pack = true
		folder_changed = true
		on_done()
	setup_done.connect(on_done)
	ErrorManager.error_alert.connect(on_error)
	%confirmButton.set_disabled()
	%pathOpenButton.button_pressed.connect(on_path_button_pressed)
	%coatsButton.button_pressed.connect(on_coats_selected)
	%packButton.button_pressed.connect(on_pack_selected)
	$errorMessage.error_continue.connect(on_error_continue)
	%nameCheck.button_pressed.connect(on_name_check)
	$popUP.deny.connect(on_popup_back)
	$popUP.confirm.connect(on_popup_confirmed)
	$popUP2.deny.connect(on_popup_leave_back)
	$popUP2.confirm.connect(on_popup_leave_confirmed)
	$popUP3.deny.connect(_on_pop_up_new_deny)
	$popUP3.confirm.connect(_on_pop_up_new_confirm)
	$helpscreen.visible = true

func _on_confirm_button_pressed() -> void:
	$popUPload.loading("Checking pack path")
	var Root = location_text.text
	var folder = folder_nametext.text
	Root = GlobalScripts.path_clean(Root)
	folder = GlobalScripts.path_clean(folder)
	GlobalScripts.root = Root
	GlobalScripts.folder = folder
	GlobalScripts.resourcepackname = %S2_java_name.text
	directory = GlobalScripts.join_paths(Root, folder)
	
	if GlobalScripts.check_folder(directory):
		$popUPload.stop_loading()
		folder_exists()
	else:
		$popUPload.loading("Creating new pack")
		GlobalScripts.new_pack_setup(directory)
		old_pack = false
		setup_done.emit()

func on_done() -> void:
	$popUPload.stop_loading()
	if ErrorManager.is_error:
		pass
	else:
		%confirmButton.visible = false
		%newpackButton.visible = true
		$NinePatchRect/VBoxContainer/Stage1BoxContainer.visible = false
		%confirmButton.visible = false
		$NinePatchRect/VBoxContainer/Stage2BoxContainer.visible = true
		$NinePatchRect/VBoxContainer/HelperLabel.visible = false
		$checkPathLOCA.visible = false
		$checkPathFOLD.visible = false
		%nameCheck.set_disabled()
		%pathOpenButton.set_disabled()
		location_text.editable = false
		folder_nametext.editable = false
		%S2_java_name.text = GlobalScripts.text_clean(folder_nametext.text)
		if old_pack:
			$NinePatchRect/VBoxContainer/Stage2BoxContainer/Stage2Text.text  = \
			"\"" + GlobalScripts.folder + "\" folder has been opened!"
		else:
			$NinePatchRect/VBoxContainer/Stage2BoxContainer/Stage2Text.text  = \
			"\"" + GlobalScripts.folder + "\" folder has been generated!"

func disable_interaction() -> void:
	%confirmButton.set_disabled()
	%backButton.disabled = true
	%nameCheck.set_disabled()
	%pathOpenButton.set_disabled()
	location_text.editable = false
	folder_nametext.editable = false
	%coatsButton.set_disabled()
	%newpackButton.set_disabled()
	%packButton.set_disabled()

func enable_interaction() -> void:
	%confirmButton.reenable_button()
	%backButton.disabled = false
	%nameCheck.reenable_button()
	%pathOpenButton.reenable_button()
	location_text.editable = true
	folder_nametext.editable = true
	%coatsButton.reenable_button()
	%newpackButton.reenable_button()
	%packButton.reenable_button()

func on_coats_selected() -> void:
	TransitionFade.transition()
	await TransitionFade.transition_finished
	get_tree().change_scene_to_file("res://scene/coatGUI.tscn")

func on_pack_selected() -> void:
	TransitionFade.transition()
	await TransitionFade.transition_finished
	get_tree().change_scene_to_file("res://scene/packGUI.tscn")

func _on_location_text_text_changed(_new_text: String) -> void:
	$checkPathLOCA.awaiting_check()
	root_changed = false
	%confirmButton.set_disabled() 

func _on_folder_nametext_text_changed(_new_text: String) -> void:
	$checkPathFOLD.awaiting_check()
	folder_changed = false
	%confirmButton.set_disabled()

func on_error() -> void:
	$popUPload.stop_loading()
	root_changed = false
	%confirmButton.set_disabled()
	%backButton.disabled = true

func on_error_continue() -> void:
	$popUPload.stop_loading()
	$checkPathFOLD.set_check(false)
	$checkPathLOCA.set_check(false)
	root_changed = false
	folder_changed = false
	%confirmButton.set_disabled()
	%backButton.disabled = false
	
func _on_back_button_pressed() -> void:
	var title = "Wait!"
	var message = "\nAre you sure you want to exit?"
	var no_label = " NO"
	var yes_label = "YES "
	$popUP2.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_path_button_pressed() -> void:
	$FileDialog.current_dir = location_text.text
	$FileDialog.visible = true
	$FileDialog.title = "Select where to save the pack folder"

func on_name_check() -> void:
	if folder_nametext.text == "":
		$checkPathFOLD.set_check(false)
		folder_changed = false
	else:
		folder_nametext.text = GlobalScripts.to_alphanumeric(folder_nametext.text, false, true)
		%S1_java_name.text = GlobalScripts.text_clean(folder_nametext.text)
		%S2_java_name.text = GlobalScripts.text_clean(folder_nametext.text)
		$checkPathFOLD.set_check(true)
		folder_changed = true
		if root_changed == true:
			%confirmButton.reenable_button()
		else:
			pass

func folder_exists() -> void:
	var title = "This folder already exists!"
	var message = "There already exists a pack folder named '" + folder_nametext.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Open it"
	$popUP.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_back() -> void:
	enable_interaction()

func on_popup_confirmed() -> void:
	$popUPload.loading("Opening up pack")
	var opened_dir= DirAccess.open(directory)
	GlobalScripts.old_pack_setup(directory)
	old_pack = true
	enable_interaction()
	setup_done.emit()

func on_popup_leave_back() -> void:
	enable_interaction()

func on_popup_leave_confirmed() -> void:
	get_tree().quit()

func _on_location_text_focus_exited() -> void:
	location_text.text = GlobalScripts.path_clean(location_text.text)
	if GlobalScripts.check_folder(location_text.text):
		$checkPathLOCA.set_check(true)
		root_changed = true
		if folder_changed == true:
			%confirmButton.reenable_button()
		else:
			pass
	else:
		$checkPathLOCA.set_check(false)
		root_changed = false


func _on_file_dialog_dir_selected(dir: String) -> void:
	location_text.text = dir
	_on_location_text_focus_exited()


func _on_newpack_button_button_pressed() -> void:
	var title = "Are you sure..."
	var message = "...you want to stop working on " + GlobalScripts.folder + " and start on a new pack?"
	var no_label = "No"
	var yes_label = "Yes"
	$popUP3.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func _on_pop_up_new_confirm() -> void:
	GlobalScripts.restart()
	enable_interaction()
	get_tree().reload_current_scene()

func _on_pop_up_new_deny() -> void:
	enable_interaction()
