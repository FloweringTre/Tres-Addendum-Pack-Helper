extends Control


var file_name : String
var path : String

var image_icon : Image
var text_icon : bool = false
var icon_save_path : String
var icon_source : String

signal pack_saved

var has_been_saved : bool = true

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$errorMessage.error_continue.connect(on_error_continue)
	pack_saved.connect(on_pack_saved)
	$popUP_Saved.deny.connect(on_popup_saved_back)
	$popUP_Saved.confirm.connect(on_popup_saved_confirmed)
	$popUP2_Dupe.deny.connect(on_popup_dupe_back)
	$popUP2_Dupe.confirm.connect(on_popup_dupe_confirmed)
	$popUPexit.deny.connect(on_popup_exit_back)
	$popUPexit.confirm.connect(on_popup_exit_confirmed)
	$helpscreen.visible = true
	$FileDialog.current_dir = GlobalScripts.directory_root
	%descriptionTextEdit.text = GlobalScripts.description
	ready_to_save()

func disable_interaction () -> void:
	%confirmButton.set_disabled()
	%backButton.set_disabled()
	%iconButton.set_disabled()
	%descriptionTextEdit.editable = false

func enable_interaction () -> void:
	%confirmButton.reenable_button()
	%backButton.reenable_button()
	%iconButton.reenable_button()
	%descriptionTextEdit.editable = true

func on_error() -> void:
	$popUPload.stop_loading()
	disable_interaction()

func on_error_continue() -> void:
	$popUPload.stop_loading()
	enable_interaction()

########### BUTTON LOGGING ################

func _on_back_button_pressed() -> void:
	if !has_been_saved:
		are_you_sure()
	else:
		TransitionFade.transition()
		await TransitionFade.transition_finished
		get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func _on_description_text_edit_text_changed() -> void:
	has_been_saved = false
	ready_to_save()

func ready_to_save() -> void:
	if !has_been_saved:
		%confirmButton.reenable_button()
	else:
		%confirmButton.set_disabled()

#################### SAVING PROCESS ######################

func _on_confirm_button_pressed() -> void:
	$popUPload.loading("Checking for duplicates")
	disable_interaction()
	file_name = "pack.png"
	icon_save_path = GlobalScripts.join_paths(GlobalScripts.directory_root, file_name)
	
	if GlobalScripts.check_file_exists(icon_save_path):
		$popUPload.stop_loading()
		icon_exists()
	else:
		save_data()

func save_data() -> void:
	$popUPload.loading("Saving icon")
	image_icon.save_png(icon_save_path)
	GlobalScripts.report("Saved user selected image: " + icon_source + "  to the file location: " + icon_save_path)
	
	GlobalScripts.description = %descriptionTextEdit.text
	GlobalScripts.set_up_pack_mcmeta("user updated value")
	GlobalScripts.report("Updated desciption of pack.mcmeta to: " + %descriptionTextEdit.text)
	
	$popUPload.stop_loading()
	pack_saved.emit()

func icon_exists() -> void:
	var title = "An icon already exists!"
	var message = "This resource pack already has an icon. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

#region ############### POP UP HANDLING ##########################

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	save_data()

func on_pack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully pack information. \nWhat do you want to do now?"
	var no_label = "Return to Menu"
	var yes_label = "Stay here"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_saved_back() -> void:
	TransitionFade.transition()
	await TransitionFade.transition_finished
	get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func on_popup_saved_confirmed() -> void:
	enable_interaction()

func are_you_sure() -> void:
	var title = "Wait a moment!"
	var message = "You have unsaved changes!\n\nAre you sure you want to return to the Main Menu?"
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
	has_been_saved = false
	ready_to_save()
	icon_source = path
	image_icon = Image.load_from_file(selected_path)
	%iconButton.button_label.text = "Icon"

	var image_file_name = selected_path.split("\\")
	image_file_name = image_file_name[-1]
	%iconLineEdit.text = " " + image_file_name

func _on_render_button_button_pressed() -> void:
	$FileDialog.title = "Select the Pack Icon"
	$FileDialog.visible = true

#endregion
