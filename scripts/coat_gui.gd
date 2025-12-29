extends Control

var has_wings : bool = false
var breed : String = "irish_draught"
var fancy_breed: String = "Irish Draught - SWEM Base Model"

var coat_name : bool = false

var file_name : String
var path : String

var image_coat : Image
var image_wing : Image
var text_coat : bool = false
var text_wing : bool = false
var coat_save_path : String
var coat_source : String
var wing_save_path : String
var wing_source : String

var dialog_opened : String 

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
	$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3.visible = has_wings
	ready_to_save()

func disable_interaction () -> void:
	%confirmButton.set_disabled()
	%backButton.set_disabled()
	%coatText.editable = false
	%renderButton.set_disabled()
	%nameCheck.set_disabled()
	%wingButton.set_disabled()
	%breedoptions.disabled = true
	%wingsCheckBox.disabled = true

func enable_interaction () -> void:
	%confirmButton.reenable_button()
	%backButton.reenable_button()
	%coatText.editable = true
	%renderButton.reenable_button()
	%nameCheck.reenable_button()
	%wingButton.reenable_button()
	%breedoptions.disabled = false
	%wingsCheckBox.disabled = false

func on_error() -> void:
	$popUPload.stop_loading()
	disable_interaction()

func on_error_continue() -> void:
	$popUPload.stop_loading()
	enable_interaction()

########### BUTTON LOGGING ################

func _on_back_button_pressed() -> void:
	if %coatText.text != "" or text_coat:
		are_you_sure()
	else:
		TransitionFade.transition()
		await TransitionFade.transition_finished
		get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func _on_coat_text_text_changed(_new_text: String) -> void:
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

func _on_wings_check_box_pressed() -> void:
	if has_wings:
		has_wings = false
	else:
		has_wings = true
	%wingsLabel.text = "Yes" if has_wings else "No"
	$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3.visible = has_wings

func ready_to_save() -> void:
	if coat_name:
		%confirmButton.reenable_button()
	else:
		%confirmButton.set_disabled()

#################### SAVING PROCESS ######################

func _on_confirm_button_pressed() -> void:
	if (breed != "irish_draught") and (breed != "pegasus"):
		has_wings = false
		print(breed, " -  wing status - ", has_wings)
	
	$popUPload.loading("Checking for duplicates")
	disable_interaction()
	GlobalScripts.make_coat_folder(breed)
	on_name_check()
	file_name = %coatText.text + ".png"
	path = GlobalScripts.join_paths(GlobalScripts.textures_root, breed)
	path = GlobalScripts.join_paths(path, file_name)
	
	if GlobalScripts.check_file_exists(path):
		$popUPload.stop_loading()
		coat_exists()
	else:
		save_coat()

func save_coat() -> void:
	$popUPload.loading("Saving coat")
	var save_path = GlobalScripts.join_paths(GlobalScripts.textures_root, breed)
	if text_coat:
		coat_save_path = save_path + "/" + %coatText.text + ".png"
		image_coat.save_png(coat_save_path)
		GlobalScripts.report("Saved user selected image: " + coat_source + "  to the file location: " + coat_save_path)
	else:
		GlobalScripts.instructions_coat(%coatText.text, save_path, has_wings)
	
	if has_wings:
		if text_wing:
			wing_save_path = save_path + "/" + %coatText.text + "_wing.png"
			image_coat.save_png(wing_save_path)
			GlobalScripts.report("Saved user selected image: " + wing_source + "  to the file location: " + wing_save_path)
	
	GlobalScripts.summon_log(%coatText.text, fancy_breed)
	$popUPload.stop_loading()
	new_coat_saved.emit()

func coat_exists() -> void:
	var title = "This coat already exists!"
	var message = "There already exists a coat named '" + %coatText.text + "'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

#region ############### POP UP HANDLING ##########################

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
	TransitionFade.transition()
	await TransitionFade.transition_finished
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
	TransitionFade.transition()
	await TransitionFade.transition_finished
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")
#endregion

#region Image values
func _on_file_dialog_file_selected(selected_path: String) -> void:
	if dialog_opened == "coat":
		text_coat = true
		coat_source = path
		image_coat = Image.load_from_file(selected_path)
		%renderButton.button_label.text = "Coat"

		var image_file_name = selected_path.split("\\")
		image_file_name = image_file_name[-1]
		%renderLineEdit.text = " " + image_file_name
	if dialog_opened == "wing":
		text_wing = true
		wing_source = path
		image_wing = Image.load_from_file(selected_path)
		%wingButton.button_label.text = "Wing"

		var image_file_name = selected_path.split("\\")
		image_file_name = image_file_name[-1]
		%wingLineEdit.text = " " + image_file_name

func _on_render_button_button_pressed() -> void:
	dialog_opened = "coat"
	$FileDialog.title = "Select the Coat Texture"
	$FileDialog.visible = true

func _on_wing_button_button_pressed() -> void:
	dialog_opened = "wing"
	$FileDialog.title = "Select the Wing Texture"
	$FileDialog.visible = true
#endregion

func _on_breedoptions_item_selected(index: int) -> void:
	$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer/wings.visible = false
	$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3.visible = false
	match index:
		0:
			breed = "american_quarter_horse"
			fancy_breed = "American Quarter Horse"
		1:
			breed = "arabian"
			fancy_breed = "Arabian"
		2:
			breed = "breton"
			fancy_breed = "Breton"
		3:
			breed = "donkey"
			fancy_breed = "Donkey"
		4:
			breed = "fjord"
			fancy_breed = "Fjord"
		5:
			breed = "friesian"
			fancy_breed = "Friesian"
		6:
			breed = "irish_draught"
			fancy_breed = "Irish Draught - SWEM Base Model"
			$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer/wings.visible = true
			$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3.visible = has_wings
		7:
			breed = "kladruber"
			fancy_breed = "Kladruber"
		8:
			breed = "knabstrupper"
			fancy_breed = "Knabstrupper"
		9:
			breed = "marwari"
			fancy_breed = "Marwari"
		10:
			breed = "mule"
			fancy_breed = "Mule"
		11:
			breed = "mustang"
			fancy_breed = "Mustang"
		12:
			breed = "pegasus"
			fancy_breed = "Pegasus"
			$NinePatchRect/VBoxContainer/HBoxContainer/VBoxContainer/wings.visible = true
			%wingsCheckBox.button_pressed = true
			_on_wings_check_box_pressed()
		13:
			breed = "shire"
			fancy_breed = "Shire"
		14:
			breed = "thoroughbred"
			fancy_breed = "Thoroughbred"
		15:
			breed = "turkoman"
			fancy_breed = "Turkoman"
		16:
			breed = "warmblood"
			fancy_breed = "Warmblood"
		17:
			breed = "steed_foal"
			fancy_breed = "Steed Foal Coat"
