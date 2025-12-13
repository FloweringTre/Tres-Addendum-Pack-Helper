extends Control

var artist : bool = false
var set_name : bool = false
var set_armor : bool = false
var set_coin : bool = false
var set_tack : bool = false

var type_tack : String
var adventure : bool = false

var custom_rack : bool = false
var red : float = 255.0
var green : float = 255.0
var blue : float = 255.0
var coin : String
var armor : String

var arpb : bool = true
var pb : bool = true
var ar : bool = true
var sb : bool = true
var hal : bool = true

var file_name : String
var path : String

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
	update_name_previews()
	if GlobalScripts.artist != "":
		%artistText.text = GlobalScripts.artist
		artist = true
	ready_to_save()

func on_error() -> void:
	$popUPload.stop_loading()
	disable_interaction()

func on_error_continue() -> void:
	enable_interaction()

func _on_back_button_pressed() -> void:
	if %artistText.text != "" or %inspoText.text != "" or %tackText.text != "":
		are_you_sure()
	else:
		get_tree().change_scene_to_file("res://scene/tackMenuGUI.tscn")

func disable_interaction() -> void:
	%confirmButton.set_disabled()
	%backButton.set_disabled()
	%artistText.editable = false
	%inspoText.editable = false
	%tackText.editable = false
	%westCheckBox.disabled = true
	%engCheckBox.disabled = true
	%armorCheckBox.disabled = true
	%custCheckBox.disabled = true
	%redSpinBox.editable = false
	%greenSpinBox.editable = false
	%blueSpinBox.editable = false
	%armorOptions.disabled = true
	%coinOptions.disabled = true
	%arpbCheckBox.disabled = true
	%pbCheckBox.disabled = true
	%arCheckBox.disabled = true
	%sbCheckBox.disabled = true
	%halCheckBox.disabled = true

func enable_interaction() -> void:
	%confirmButton.reenable_button()
	%backButton.reenable_button()
	%artistText.editable = true
	%inspoText.editable = true
	%tackText.editable = true
	%westCheckBox.disabled = false
	%engCheckBox.disabled = false
	%armorCheckBox.disabled = false
	%custCheckBox.disabled = false
	%redSpinBox.editable = true
	%greenSpinBox.editable = true
	%blueSpinBox.editable = true
	%armorOptions.disabled = false
	%coinOptions.disabled = false
	%arpbCheckBox.disabled = false
	%pbCheckBox.disabled = false
	%arCheckBox.disabled = false
	%sbCheckBox.disabled = false
	%halCheckBox.disabled = false


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
	%inGameLabel.text = text + " Bridle"
	%dataLabel.text = GlobalScripts.text_clean(text) + "_bridle"

func _on_armor_check_box_pressed() -> void:
	if adventure:
		adventure = false
		%armorLabel.text = "No"
	else:
		adventure = true
		%armorLabel.text = "Yes"

func _on_cust_check_box_pressed() -> void:
	if custom_rack:
		custom_rack = false
		%custLabel.text = "No"
		%STATICBoxContainer.visible = false
		%EDITBoxContainer.visible = true
	else:
		custom_rack = true
		%custLabel.text = "Yes"
		%STATICBoxContainer.visible = true
		%EDITBoxContainer.visible = false

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

func _on_armor_options_item_selected(index: int) -> void:
	set_armor = true
	ready_to_save()
	match index:
		0:
			armor = "cloth"
		1:
			armor = "iron"
		2:
			armor = "gold"
		3:
			armor = "diamond"
		4:
			armor = "amethyst"

func _on_arpb_check_box_pressed() -> void:
	if arpb:
		arpb = false
		%arpbLabel.text = "No"
	else:
		arpb = true
		%arpbLabel.text = "Yes"

func _on_pb_check_box_pressed() -> void:
	if pb:
		pb = false
		%pbLabel.text = "No"
	else:
		pb = true
		%pbLabel.text = "Yes"

func _on_ar_check_box_pressed() -> void:
	if ar:
		ar = false
		%arLabel.text = "No"
		%armorOptions.disabled = true
		%armoredrequired.text = ""
	else:
		ar = true
		%arLabel.text = "Yes"
		%armorOptions.disabled = false
		%armoredrequired.text = "*"
	ready_to_save()

func _on_sb_check_box_pressed() -> void:
	if sb:
		sb = false
		%sbLabel.text = "No"
	else:
		sb = true
		%sbLabel.text = "Yes"

func _on_hal_check_box_pressed() -> void:
	if hal:
		hal = false
		%halLabel.text = "No"
	else:
		hal = true
		%halLabel.text = "Yes"

func ready_to_save() -> void:
	#print("run ready_to_save")
	if artist && set_name && set_coin && set_tack:
		if !ar or set_armor:
			%confirmButton.reenable_button()
		else:
			%confirmButton.set_disabled()
	else:
		%confirmButton.set_disabled()

#########################################################
func _on_confirm_button_pressed() -> void:
	disable_interaction()
	if %inspoText.text == "":
		%inspoText.text = "N/a"
	$popUPload.loading("Checking for duplicates.")
	var found_dupes = check_for_duplicates()
	if found_dupes != 0:
		$popUPload.stop_loading()
		dupe_exists(found_dupes)
	else:
		_save_complete_tack_set()

func dupe_exists(duplicates_found : int) -> void:
	var title = "Oops! Duplicates exists!"
	var message = "There are " + str(duplicates_found) + " items from this tack set that already exist in this pack. \nDo you still want to generate this tack set?"
	var no_label = "Go Back"
	var yes_label = "Generate the files"
	$popUP2_Dupe.pop_yesNo(title, message, no_label, yes_label)
	disable_interaction()

func check_for_duplicates():
	var duplicate_exists : int
	duplicate_exists += dupe_tack()
	if pb:
		if TackScripts.tack_dupe_check("pasture_blanket", %tackText.text):
			duplicate_exists += 1
	if arpb:
		if TackScripts.tack_dupe_check("pasture_blanket_armored", %tackText.text):
			duplicate_exists += 1
	if ar:
		if TackScripts.tack_dupe_check("horse_armor", %tackText.text):
			duplicate_exists += 1
	if sb:
		if TackScripts.tack_dupe_check("saddle_bag", %tackText.text):
			duplicate_exists += 1
	if hal:
		if TackScripts.tack_dupe_check("halter", %tackText.text):
			duplicate_exists += 1
	return duplicate_exists

func dupe_tack():
	var duplicate_exists : int
	if TackScripts.tack_dupe_check("saddle", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("bridle", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("blanket", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("leg_wraps", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("girth_strap", %tackText.text):
		duplicate_exists += 1
	if TackScripts.tack_dupe_check("breast_collar", %tackText.text):
		duplicate_exists += 1
	return duplicate_exists

func _save_complete_tack_set() -> void:
	# THE TACK SETS
	save_tack()
		
	#CUSTOM RACK TEXTURES
	if custom_rack:
		if ErrorManager.is_error:
			return
		else:
			if pb:
				$popUPload.loading("Saving Pasture Blanket")
				TackScripts.pasture_blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, false, false, false, false)
			if arpb:
				$popUPload.loading("Saving Armored Pasture Blanket")
				TackScripts.ar_pasture_blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, false, false, false, false)
	else:
		if ErrorManager.is_error:
			return
		else:
			if pb:
				$popUPload.loading("Saving Pasture Blanket")
				TackScripts.colored_pasture_blanket_save(%Past_5Long, %Past_3Short, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, false, false)
			if arpb:
				$popUPload.loading("Saving Armored Pasture Blanket")
				TackScripts.colored_ar_pasture_blanket_save(%ArmPast_5Long, %ArmPast_3Short, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, false, false)
	
	#ONE OFFS & OPTIONAL
	if ErrorManager.is_error:
		return
	else:
		if ar: # armor
			$popUPload.loading("Saving Armor")
			TackScripts.armor_save(%tackText.text, %artistText.text, %inspoText.text, coin, armor, false, false, false, false)
		
		if sb: #saddle bag
			$popUPload.loading("Saving Saddle Bag")
			TackScripts.saddle_bag_save(%tackText.text, %artistText.text, %inspoText.text, coin, false, false)
		
		if hal: #halter
			$popUPload.loading("Saving Halter")
			TackScripts.halter_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, false, false, false)
	if ErrorManager.is_error:
		return
	else:
		$popUPload.stop_loading()
		new_tack_saved.emit()

func save_tack() -> void:
	if ErrorManager.is_error:
		return
	else:
		$popUPload.loading("Saving Saddle and Bridle")
		TackScripts.saddle_save(%tackText.text, %artistText.text, %inspoText.text, coin, type_tack, adventure, false, false, false)
		TackScripts.bridle_save(%tackText.text, %artistText.text, %inspoText.text, coin, type_tack, adventure, false, false, false, false)
	if ErrorManager.is_error:
		return
	else:
		$popUPload.loading("Saving Breast Collar and Leg Wraps")
		TackScripts.breast_collar_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, false, false)
		TackScripts.leg_wraps_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, false, false, false)
	
	$popUPload.loading("Saving Saddle Blanket and Girth Strap")
	if custom_rack:
		if ErrorManager.is_error:
			return
		else:
			TackScripts.girth_straps_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, false, false, false)
			TackScripts.blanket_save(%tackText.text, %artistText.text, %inspoText.text, coin, adventure, false, false, false, false)
	else:
		if ErrorManager.is_error:
			return
		else:
			TackScripts.colored_girth_strap_save(%Girth_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, false, false)
			if type_tack == "english":
				TackScripts.colored_blanket_save(%Eng_Blanket5, %Eng_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, false, false)
			else:
				TackScripts.colored_blanket_save(%West_Blanket5, %West_Saddle, %tackText.text, %artistText.text, %inspoText.text, coin, red, green, blue, adventure, false, false)

func on_popup_dupe_back() -> void:
	enable_interaction()

func on_popup_dupe_confirmed() -> void:
	_save_complete_tack_set()

func on_new_tack_saved() -> void:
	var title = "Complete!"
	var message = "Successfully added '" + %tackText.text + "' Tack Set to the pack folder. \nWhat do you want to do now?"
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

func _on_tack_check_button_item_selected(index: int) -> void:
	set_tack = true
	ready_to_save()
	match index:
		0:
			type_tack = "western"
			%armorCheckBox.disabled = false
		1:
			type_tack = "english"
			%armorCheckBox.disabled = false
		2:
			type_tack = "adventure"
			adventure = true
			%armorLabel.text = "Yes"
			%armorCheckBox.button_pressed = true
			%armorCheckBox.disabled = true
