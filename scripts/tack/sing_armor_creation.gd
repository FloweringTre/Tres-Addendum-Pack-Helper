extends Control

var artist : bool = false
var set_name : bool = false
var set_coin : bool = false
var set_armor : bool = false

var armor : String = ""

var text_icon : bool = false
var text_render_armor : bool = false
var text_render_wings : bool = false
var text_rack : bool = false

var image_icon : Image
var image_render_armor : Image
var image_render_wings : Image
var image_rack : Image
var icon_save_path : String
var render_save_path_armor : String
var render_save_path_wings : String
var rack_save_path : String
var icon_source : String
var render_source_armor : String
var render_source_wings : String
var rack_source : String

var coin : String

var file_name : String
var path : String
var file_opened : String

signal new_tack_saved

func _ready() -> void:
	ErrorManager.error_alert.connect(on_error)
	$errorMessage.error_continue.connect(on_error_continue)
	new_tack_saved.connect(on_new_tack_saved)
	$popUP_Saved.deny.connect(on_popup_saved_back)
	$popUP_Saved.confirm.connect(on_popup_saved_confirmed)
	$popUP2_Dupe.deny.connect(on_popup_dupe_back)
	$popUP2_Dupe.confirm.connect(on_popup_dupe_confirmed)
	$popUPexit.deny.connect(on_popup_exit_denied)
	$popUPexit.confirm.connect(on_popup_exit_confirmed)
	$helpscreen.visible = true
	$FileDialog.current_dir = GlobalScripts.directory_root
	update_name_previews()
	starting_coin_values()
	if GlobalScripts.artist != "":
		%artistText.text = GlobalScripts.artist
		artist = true
	ready_to_save()

func on_error() -> void:
	$popUPload.stop_loading()
	disable_interaction()

func on_error_continue() -> void:
	$popUPload.stop_loading()
	enable_interaction()

func _on_back_button_pressed() -> void:
	if %artistText.text != "" or %inspoText.text != "" or %tackText.text != "" or text_icon or text_render_armor or text_render_wings or text_rack:
		are_you_sure()
	else:
		get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func disable_interaction() -> void:
	%confirmButton.set_disabled()
	%backButton.set_disabled()
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false
	%coinOptions.disabled = true
	%armorSpinBox.editable = false
	%armorOptions.disabled = true
	%iconButton.set_disabled()
	%renderButton.set_disabled()
	%renderWingsButton.set_disabled()
	%rackButton.set_disabled()

func enable_interaction() -> void:
	%confirmButton.reenable_button()
	%backButton.reenable_button()
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true
	%coinOptions.disabled = false
	%armorSpinBox.editable = true
	%armorOptions.disabled = false
	%iconButton.reenable_button()
	%renderButton.reenable_button()
	%renderWingsButton.reenable_button()
	%rackButton.reenable_button()

################### VALUE LOGGING ######################
func _on_artist_text_text_changed(new_text: String) -> void:
	if %artistText.text != "":
		artist = true
	else:
		artist = false
	ready_to_save()

func _on_tack_text_text_changed(new_text: String) -> void:
	update_name_previews()
	if %tackText.text != "":
		set_name = true
	else:
		set_name = false
	ready_to_save()

func update_name_previews() -> void:
	var text = ""
	if %tackText.text == "":
		text = "Indigo"
	else:
		text = %tackText.text
	%inGameLabel.text = text + " Horse Armor"
	%dataLabel.text = GlobalScripts.text_clean(text) + "_horse_armor"

func _on_armor_options_item_selected(index: int) -> void:
	set_armor = true
	ready_to_save()
	match index:
		0:
			armor = "cloth"
			%renderWingsButton.visible = false
			%renderWingsLineEdit.visible = false
		1:
			armor = "iron"
			%renderWingsButton.visible = false
			%renderWingsLineEdit.visible = false
		2:
			armor = "gold"
			%renderWingsButton.visible = false
			%renderWingsLineEdit.visible = false
		3:
			armor = "diamond"
			%renderWingsButton.visible = false
			%renderWingsLineEdit.visible = false
		4:
			armor = "amethyst"
			%renderWingsButton.visible = true
			%renderWingsLineEdit.visible = true

func _on_coin_options_item_selected(index: int) -> void:
	set_coin = true
	ready_to_save()
	match index:
		0:
			coin = "copper"
		1:
			coin = "iron"
		2:
			coin = "emerald"
		3:
			coin = "gold"
		4:
			coin = "diamond"
		5:
			coin = "netherite"
		6:
			coin = "amethyst"

func ready_to_save() -> void:
	if artist && set_name && set_coin && set_armor:
		%confirmButton.reenable_button()
	else:
		%confirmButton.set_disabled()

#########################################################
func _on_confirm_button_pressed() -> void:
	if %inspoText.text == "":
		%inspoText.text = "N/a"
	$popUPload.loading("Checking for duplicates")
	disable_interaction()
	if TackScripts.tack_dupe_check("horse_armor", %tackText.text):
		$popUPload.stop_loading()
		dupe_exists()
	else:
		_save_tack()

func dupe_exists() -> void:
	var title = "This item already exists!"
	var message = "There already exists an item named '" + %tackText.text + " Horse Armor'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func _save_tack() -> void:
	$popUPload.loading("Saving Armor")
	var save_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack/horse_armor")
	TackScripts.armor_save(%tackText.text, %artistText.text, %inspoText.text, coin, armor, text_icon, text_render_armor, text_render_wings, text_rack, %armorSpinBox.value)
	
	if text_icon:
		icon_save_path = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + "_horse_armor_icon.png"
		image_icon.save_png(icon_save_path)
		GlobalScripts.report("Saved user selected image: " + icon_source + "  to the file location: " + icon_save_path)
	if text_render_armor:
		render_save_path_armor = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + "_horse_armor_legacy.png"
		image_render_armor.save_png(render_save_path_armor)
		GlobalScripts.report("Saved user selected image: " + render_source_armor + "  to the file location: " + render_save_path_armor)
	if text_render_wings:
		render_save_path_wings = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + "_horse_armor_wings_legacy.png"
		image_render_wings.save_png(render_save_path_wings)
		GlobalScripts.report("Saved user selected image: " + render_source_wings + "  to the file location: " + render_save_path_wings)
	if text_rack:
		rack_save_path = save_path + "/rack_horse_armor_" + GlobalScripts.text_clean(%tackText.text) + "_horse_armor.png"
		image_rack.save_png(rack_save_path)
		GlobalScripts.report("Saved user selected image: " + rack_source + "  to the file location: " + rack_save_path)
	
	if ErrorManager.is_error:
			return
	else:
		$popUPload.stop_loading()
		new_tack_saved.emit()

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	_save_tack()

func on_new_tack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %tackText.text + " Horse Armor' to the pack folder. \nWhat do you want to do now?"
	var no_label = "Return to Menu"
	var yes_label = "Make Another"
	$popUP_Saved.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_saved_back() -> void:
	get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func on_popup_saved_confirmed() -> void:
	enable_interaction()
	get_tree().reload_current_scene()

func are_you_sure() -> void:
	var title = "Wait a moment!"
	var message = "Are you sure you want to return to the Tack Menu?"
	var no_label = "Go Back"
	var yes_label = "Continue to Menu"
	$popUPexit.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func on_popup_exit_denied() -> void:
	enable_interaction()

func on_popup_exit_confirmed() -> void:
	get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

###########################################################

func starting_coin_values() -> void:
	%armorSpinBox.value = TackScripts.cost_armor

func _on_file_dialog_file_selected(path: String) -> void:
	var target_line : LineEdit
	if file_opened == "icon":
		target_line = %iconLineEdit
		text_icon = true
		icon_source = path
		image_icon = Image.load_from_file(path)
		%iconButton.button_label.text = "Icon"
	
	if file_opened == "render_armor":
		target_line = %renderLineEdit
		text_render_armor = true
		render_source_armor = path
		image_render_armor = Image.load_from_file(path)
		%renderButton.button_label.text = "Armor"
	
	if file_opened == "render_wings":
		target_line = %renderWingsLineEdit
		text_render_wings = true
		render_source_wings = path
		image_render_wings = Image.load_from_file(path)
		%renderWingsButton.button_label.text = "Wings"
	
	if file_opened == "rack":
		target_line = %rackLineEdit
		text_rack = true
		rack_source = path
		image_rack = Image.load_from_file(path)
		%rackButton.button_label.text = "Rack"
	
	var image_file_name = path.split("\\")
	image_file_name = image_file_name[-1]
	target_line.text = " " + image_file_name

func _on_icon_button_button_pressed() -> void:
	file_opened = "icon"
	$FileDialog.title = "Select the Icon Texture"
	$FileDialog.visible = true

func _on_render_button_button_pressed() -> void:
	file_opened = "render_armor"
	$FileDialog.title = "Select the Armor Texture"
	$FileDialog.visible = true

func _on_rack_button_button_pressed() -> void:
	file_opened = "rack"
	$FileDialog.title = "Select the Rack Texture"
	$FileDialog.visible = true

func _on_render_wings_button_button_pressed() -> void:
	file_opened = "render_wings"
	$FileDialog.title = "Select the Wings Texture"
	$FileDialog.visible = true
