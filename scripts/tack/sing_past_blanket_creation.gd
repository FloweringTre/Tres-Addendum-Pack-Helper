extends Control

var artist : bool = false
var set_name : bool = false
var set_coin : bool = false

var custom_rack : bool = false
var red : float = 255.0
var green : float = 255.0
var blue : float = 255.0

var adventure : bool = false

var text_icon : bool = false
var text_render : bool = false
var text_rack_long : bool = false
var text_rack_short : bool = false

var image_icon : Image
var image_render : Image
var image_rack_long : Image
var image_rack_short : Image
var icon_save_path : String
var render_save_path : String
var rack_save_path_long : String
var rack_save_path_short : String
var icon_source : String
var render_source : String
var rack_source_long : String
var rack_source_short : String

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
	if %artistText.text != "" or %inspoText.text != "" or %tackText.text != "" or text_icon or text_render or text_rack_long or text_rack_short:
		are_you_sure()
	else:
		get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func disable_interaction() -> void:
	%confirmButton.set_disabled()
	%backButton.set_disabled()
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false
	%armorCheckBox.disabled = true
	%coinOptions.disabled = true
	%armoredblanketSpinBox.editable = false
	%blanketSpinBox.editable = false
	%iconButton.set_disabled()
	%renderButton.set_disabled()
	%rack_longButton.set_disabled()
	%rack_shortButton.set_disabled()
	%redSpinBox.editable = false
	%greenSpinBox.editable = false
	%blueSpinBox.editable = false
	%custCheckBox.disabled = true

func enable_interaction() -> void:
	%confirmButton.reenable_button()
	%backButton.reenable_button()
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true
	%armorCheckBox.disabled = false
	%coinOptions.disabled = false
	%armoredblanketSpinBox.editable = true
	%blanketSpinBox.editable = true
	%iconButton.reenable_button()
	%renderButton.reenable_button()
	%rack_longButton.reenable_button()
	%rack_shortButton.reenable_button()
	%redSpinBox.editable = true
	%greenSpinBox.editable = true
	%blueSpinBox.editable = true
	%custCheckBox.disabled = false

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
	if adventure:
		%inGameLabel.text = "Armored " + text + " Pasture Blanket"
		%dataLabel.text = GlobalScripts.text_clean(text) + "_armored_pasture_blanket"
	else:
		%inGameLabel.text = text + " Pasture Blanket"
		%dataLabel.text = GlobalScripts.text_clean(text) + "_pasture_blanket"

func _on_armor_check_box_pressed() -> void:
	if adventure:
		adventure = false
		%armorLabel.text = "No"
		update_name_previews()
		%blanketSpinBox.visible = true
		%armoredblanketSpinBox.visible = false
	else:
		adventure = true
		%armorLabel.text = "Yes"
		update_name_previews()
		%blanketSpinBox.visible = false
		%armoredblanketSpinBox.visible = true

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
	if artist && set_name && set_coin:
		%confirmButton.reenable_button()
	else:
		%confirmButton.set_disabled()

func _on_cust_check_box_pressed() -> void:
	if custom_rack:
		custom_rack = false
		%custLabel.text = "No"
		%RackBoxContainer.visible = false
		%ColorBoxContainer.visible = true
		text_rack_short = false
		text_rack_long = false
	else:
		custom_rack = true
		%custLabel.text = "Yes"
		%RackBoxContainer.visible = true
		%ColorBoxContainer.visible = false
		if rack_source_long != "":
			text_rack_long = true
		if rack_source_short != "":
			text_rack_short = true

func _on_red_spin_box_value_changed(value: float) -> void:
	red = %redSpinBox.value
	update_color_preview()

func _on_green_spin_box_value_changed(value: float) -> void:
	green = %greenSpinBox.value
	update_color_preview()

func _on_blue_spin_box_value_changed(value: float) -> void:
	blue = %blueSpinBox.value
	update_color_preview()

func update_color_preview() -> void:
	%colorPreview.color = Color(red/255, green/255, blue/255)

#########################################################
func _on_confirm_button_pressed() -> void:
	if %inspoText.text == "":
		%inspoText.text = "N/a"
	$popUPload.loading("Checking for duplicates")
	disable_interaction()
	if adventure:
		if TackScripts.tack_dupe_check("pasture blanket_armored", %tackText.text):
			$popUPload.stop_loading()
			dupe_exists()
		else:
			_save_tack()
	else:
		if TackScripts.tack_dupe_check("pasture_blanket", %tackText.text):
			$popUPload.stop_loading()
			dupe_exists()
		else:
			_save_tack()

func dupe_exists() -> void:
	var title = ""
	var message = ""
	if adventure:
		title = "This item already exists!"
		message = "There already exists an item named '" + %tackText.text + " Armored Pasture Blanket'. \nWhat do you want to do?"
	else:
		title = "This item already exists!"
		message = "There already exists an item named '" + %tackText.text + " Pasture Blanket'. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Overwrite it"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func _save_tack() -> void:
	var save_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack/pasture_blanket")
	var type = ""
	var rack_type = ""
	if adventure:
		$popUPload.loading("Saving Armored Pasture Blanket")
		type = "_pasture_blanket_armored"
		rack_type = "_armored"
		if custom_rack:
			TackScripts.ar_pasture_blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, text_icon, text_render, text_rack_short, text_rack_long, %armoredblanketSpinBox.value)
		else:
			TackScripts.colored_ar_pasture_blanket_save(%ArmPast_5Long, %ArmPast_3Short, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, text_icon, text_render, %armoredblanketSpinBox.value)
	else:
		$popUPload.loading("Saving Pasture Blanket")
		type = "_pasture_blanket"
		rack_type = ""
		if custom_rack:
			TackScripts.pasture_blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, text_icon, text_render, text_rack_short, text_rack_long, %blanketSpinBox.value)
		else:
			TackScripts.colored_pasture_blanket_save(%Past_5Long, %Past_3Short, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, text_icon, text_render, %blanketSpinBox.value)
	
	if text_icon:
		icon_save_path = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + type + "_icon.png"
		image_icon.save_png(icon_save_path)
		GlobalScripts.report("Saved user selected image: " + icon_source + "  to the file location: " + icon_save_path)
	if text_render:
		render_save_path = save_path + "/" + GlobalScripts.text_clean(%tackText.text) + type + "_legacy.png"
		image_render.save_png(render_save_path)
		GlobalScripts.report("Saved user selected image: " + render_source + "  to the file location: " + render_save_path)
	if text_rack_short:
		rack_save_path_short = save_path + "/rack_pasture_blanket_3_short_" + GlobalScripts.text_clean(%tackText.text) + rack_type + ".png"
		image_rack_short.save_png(rack_save_path_short)
		GlobalScripts.report("Saved user selected image: " + rack_source_short + "  to the file location: " + rack_save_path_short)
	if text_rack_long:
		rack_save_path_long = save_path + "/rack_pasture_blanket_5_long_" + GlobalScripts.text_clean(%tackText.text) + rack_type + ".png"
		image_rack_long.save_png(rack_save_path_long)
		GlobalScripts.report("Saved user selected image: " + rack_source_long + "  to the file location: " + rack_save_path_long)
	
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
	var title = ""
	var message = ""
	if adventure:
		title = "Complete!"
		message = "Successfully added '" + %tackText.text + " Armored Pasture Blanket' to the pack folder. \nWhat do you want to do now?"
	else:
		title = "Complete!"
		message = "Successfully added '" + %tackText.text + " Pasture Blanket' to the pack folder. \nWhat do you want to do now?"
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
	%blanketSpinBox.value = TackScripts.cost_pasture_blanket
	%armoredblanketSpinBox.value = TackScripts.cost_ar_pasture_blanket

func _on_file_dialog_file_selected(path: String) -> void:
	var target_line : LineEdit
	
	if file_opened == "icon":
		target_line = %iconLineEdit
		text_icon = true
		icon_source = path
		image_icon = Image.load_from_file(path)
		%iconButton.button_label.text = "Icon"
	
	if file_opened == "render":
		target_line = %renderLineEdit
		text_render = true
		render_source = path
		image_render = Image.load_from_file(path)
		%renderButton.button_label.text = "Tack"
	
	if file_opened == "rack_short":
		target_line = %rack_shortLineEdit
		text_rack_short = true
		rack_source_short = path
		image_rack_short = Image.load_from_file(path)
		%rack_shortButton.button_label.text = "Short Rack"
	
	if file_opened == "rack_long":
		target_line = %rack_longLineEdit
		text_rack_long = true
		rack_source_long = path
		image_rack_long = Image.load_from_file(path)
		%rack_longButton.button_label.text = "Long Rack"

	var image_file_name = path.split("\\")
	image_file_name = image_file_name[-1]
	target_line.text = " " + image_file_name

func _on_icon_button_button_pressed() -> void:
	file_opened = "icon"
	$FileDialog.title = "Select the Icon Texture"
	$FileDialog.visible = true

func _on_render_button_button_pressed() -> void:
	file_opened = "render"
	$FileDialog.title = "Select the Tack Texture"
	$FileDialog.visible = true

func _on_rack_short_button_button_pressed() -> void:
	file_opened = "rack_short"
	$FileDialog.title = "Select the Short Rack Texture"
	$FileDialog.visible = true

func _on_rack_long_button_button_pressed() -> void:
	file_opened = "rack_long"
	$FileDialog.title = "Select the Long Rack Texture"
	$FileDialog.visible = true
