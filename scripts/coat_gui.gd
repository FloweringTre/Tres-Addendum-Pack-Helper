extends Control

var breedable : bool = true
var cyclable : bool = true
var has_wings : bool = false

var basecolors : Array
var black_coat : bool = false
var gray_coat : bool = false
var white_coat : bool = false
var creamy_coat : bool = false
var brown_coat : bool = false
var dark_brown_coat : bool = false
var chestnut_coat : bool = false

var artist : bool = false
var coat_name : bool = false

var file_name : String
var path : String

var image_coat : Image
var text_coat : bool = false
var coat_save_path : String
var coat_source : String

signal new_coat_saved

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$errorMessage.error_continue.connect(on_error_continue)
	%nameCheck.button_pressed.connect(on_name_check)
	new_coat_saved.connect(on_new_coat_saved)
	$popUP_Saved.deny.connect(on_popup_saved_back)
	$popUP_Saved.confirm.connect(on_popup_saved_confirmed)
	$popUP2_Dupe.deny.connect(on_popup_dupe_back)
	$popUP2_Dupe.confirm.connect(on_popup_dupe_confirmed)
	$popUPexit.deny.connect(on_popup_exit_back)
	$popUPexit.confirm.connect(on_popup_exit_confirmed)
	$helpscreen.visible = true
	$FileDialog.current_dir = GlobalScripts.directory_root
	if GlobalScripts.artist != "":
		%artistText.text = GlobalScripts.artist
		artist = true
	ready_to_save()

func disable_interaction () -> void:
	%confirmButton.set_disabled()
	%backButton.set_disabled()
	%artistText.editable = false
	%inspoText.editable = false
	%coatText.editable = false
	%renderButton.set_disabled()
	%nameCheck.set_disabled()
	%lapisCheckBox.disabled = true
	%breedingCheckBox.disabled = true
	%wingsCheckBox.disabled = true
	%blackCheckBox.disabled = true
	%grayCheckBox2.disabled = true
	%whiteCheckBox3.disabled = true
	%creamyCheckBox4.disabled = true
	%brownCheckBox5.disabled = true
	%d_brownCheckBox6.disabled = true
	%chestnutCheckBox7.disabled = true

func enable_interaction () -> void:
	%confirmButton.reenable_button()
	%backButton.reenable_button()
	%artistText.editable = true
	%inspoText.editable = true
	%coatText.editable = true
	%renderButton.reenable_button()
	%nameCheck.reenable_button()
	%lapisCheckBox.disabled = false
	%breedingCheckBox.disabled = false
	%wingsCheckBox.disabled = false
	%blackCheckBox.disabled = false
	%grayCheckBox2.disabled = false
	%whiteCheckBox3.disabled = false
	%creamyCheckBox4.disabled = false
	%brownCheckBox5.disabled = false
	%d_brownCheckBox6.disabled = false
	%chestnutCheckBox7.disabled = false

func on_error() -> void:
	$popUPload.stop_loading()
	disable_interaction()

func on_error_continue() -> void:
	$popUPload.stop_loading()
	enable_interaction()

########### BUTTON LOGGING ################

func _on_back_button_pressed() -> void:
	if %artistText.text != "" or %inspoText.text != "" or %coatText.text != "" or text_coat:
		are_you_sure()
	else:
		get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func _on_artist_text_text_changed(new_text: String) -> void:
	if %artistText.text != "":
		artist = true
		ready_to_save()
	else:
		artist = false
		ready_to_save()

func _on_coat_text_text_changed(new_text: String) -> void:
	$checkPath.awaiting_check()
	coat_name = false
	%confirmButton.set_disabled()
	ready_to_save()

func on_name_check() -> void:
	if %coatText.text == "":
		$checkPath.set_check(false)
		coat_name = false
		ready_to_save()
	else:
		%coatText.text = GlobalScripts.text_clean(%coatText.text)
		$checkPath.set_check(true)
		coat_name = true
		ready_to_save()

func _on_breeding_check_box_pressed() -> void:
	if breedable:
		breedable = false
		%breedingLabel.text = "No"
	else:
		breedable = true
		%breedingLabel.text = "Yes"

func _on_lapis_check_box_pressed() -> void:
	if cyclable:
		cyclable = false
		%lapisLabel.text = "No"
	else:
		cyclable = true
		%lapisLabel.text = "Yes"

func _on_wings_check_box_pressed() -> void:
	if has_wings:
		has_wings = false
	else:
		has_wings = true
	%wingsLabel.text = "Yes" if has_wings else "No"

func _on_black_check_box_pressed() -> void:
	if black_coat:
		black_coat = false
		basecolors.erase("black")
	else:
		black_coat = true
		basecolors.append("black")

func _on_gray_check_box_2_pressed() -> void:
	if gray_coat:
		gray_coat = false
		basecolors.erase("gray")
	else:
		gray_coat = true
		basecolors.append("gray")

func _on_white_check_box_3_pressed() -> void:
	if white_coat:
		white_coat = false
		basecolors.erase("white")
	else:
		white_coat = true
		basecolors.append("white")

func _on_creamy_check_box_4_pressed() -> void:
	if creamy_coat:
		creamy_coat = false
		basecolors.erase("creamy")
	else:
		creamy_coat = true
		basecolors.append("creamy")

func _on_brown_check_box_5_pressed() -> void:
	if brown_coat:
		brown_coat = false
		basecolors.erase("brown")
	else:
		brown_coat = true
		basecolors.append("brown")

func _on_d_brown_check_box_6_pressed() -> void:
	if dark_brown_coat:
		dark_brown_coat = false
		basecolors.erase("dark_brown")
	else:
		dark_brown_coat = true
		basecolors.append("dark_brown")

func _on_chestnut_check_box_7_pressed() -> void:
	if chestnut_coat:
		chestnut_coat = false
		basecolors.erase("chestnut")
	else:
		chestnut_coat = true
		basecolors.append("chestnut")

func ready_to_save() -> void:
	if artist && coat_name:
		%confirmButton.reenable_button()
	else:
		%confirmButton.set_disabled()

#################### SAVING PROCESS ######################

func _on_confirm_button_pressed() -> void:
	$popUPload.loading("Checking for duplicates")
	disable_interaction()
	GlobalScripts.setup_coats()
	on_name_check()
	file_name = %coatText.text + ".json"
	path = GlobalScripts.join_paths(GlobalScripts.jsons_root, "coats")
	path = GlobalScripts.join_paths(path, file_name)
	
	if GlobalScripts.check_file_exists(path):
		$popUPload.stop_loading()
		coat_exists()
	else:
		save_coat()

func save_coat() -> void:
	$popUPload.loading("Saving coat")
	if %inspoText.text == "":
		%inspoText.text = "N/a"
	var save_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "coats/legacy")
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var models = {
			"legacy" = "legacy/" + %coatText.text + ".png"
		}
		var part_1 = {
			"credits" = %artistText.text,
			"inspiration" = %inspoText.text,
			"models" = models,
			"lapis_cyclable" = cyclable,
			"obtainable_by_breeding" = breedable,
			"wings" = has_wings,
			"base_colors" = basecolors
		}
		
		var string_1 = JSON.stringify(part_1, "   ")
		
		file.store_string(string_1)
		file.close()
		GlobalScripts.report("Saved the new coat, " + %coatText.text + ", to " + path)
		
		if text_coat:
			coat_save_path = save_path + "/" + %coatText.text + ".png"
			image_coat.save_png(coat_save_path)
			GlobalScripts.report("Saved user selected image: " + coat_source + "  to the file location: " + coat_save_path)
		else:
			GlobalScripts.instructions_coat(%coatText.text, GlobalScripts.join_paths(GlobalScripts.textures_root, "coats/legacy") )
		$popUPload.stop_loading()
		new_coat_saved.emit()
	
	else:
		$popUPload.stop_loading()
		ErrorManager.error_print("I couldn't save the new coat. The ./json/coat/ folder wouldn't open. Check to see if it exists.")
		GlobalScripts.report("Failed to save the new coat, '" + %coatText.text + "' to " + path)

func coat_exists() -> void:
	var title = "This coat already exists!"
	var message = "There already exists a coat named '" + %coatText.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

############### POP UP HANDLING ##########################

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	save_coat()

func on_new_coat_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %coatText.text + "' to the pack folder. \nWhat do you want to do now?"
	var no_label = "Return to Menu"
	var yes_label = "Make Another"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_saved_back() -> void:
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func on_popup_saved_confirmed() -> void:
	enable_interaction()
	get_tree().reload_current_scene()

func are_you_sure() -> void:
	var title = "Wait a moment!"
	var message = "Are you sure you want to return to the Main Menu?"
	var no_label = "Go Back"
	var yes_label = "Continue to Menu"
	$popUPexit.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_exit_back() -> void:
	enable_interaction()

func on_popup_exit_confirmed() -> void:
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func _on_file_dialog_file_selected(selected_path: String) -> void:
	text_coat = true
	coat_source = path
	image_coat = Image.load_from_file(selected_path)
	%renderButton.button_label.text = "Coat"

	var image_file_name = selected_path.split("\\")
	image_file_name = image_file_name[-1]
	%renderLineEdit.text = " " + image_file_name

func _on_render_button_button_pressed() -> void:
	$FileDialog.title = "Select the Coat Texture"
	$FileDialog.visible = true
