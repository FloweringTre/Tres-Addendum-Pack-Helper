extends Control

var not_saved : bool = false
var saved_scene : String = ""

var saddle : int = 16
var bridle : int = 5
var blanket : int = 5
var halter : int = 4
var leg_wraps : int = 4
var breast_collar : int = 10
var armor : int = 64
var saddle_bag : int = 8
var girth_straps : int = 3
var pasture_blanket : int = 16
var ar_pasture_blanket : int = 32

func _ready() -> void:
	%full_set.button_pressed.connect(on_full_set)
	%saddle_set.button_pressed.connect(on_saddle_set)
	%extras_set.button_pressed.connect(on_extras_set)
	%saddles.button_pressed.connect(on_saddles)
	%bridles.button_pressed.connect(on_bridles)
	%blankets.button_pressed.connect(on_blankets)
	%girth_straps.button_pressed.connect(on_girth_straps)
	%breast_collars.button_pressed.connect(on_breast_collars)
	%leg_wraps.button_pressed.connect(on_leg_wraps)
	%halters.button_pressed.connect(on_halters)
	%saddle_bags.button_pressed.connect(on_saddle_bag)
	%armors.button_pressed.connect(on_armors)
	%pasture_blankets.button_pressed.connect(on_pasture_blankets)
	$popUP.confirm.connect(on_popup_confirmed)
	$popUP.deny.connect(on_popup_back)
	update_save_button()
	load_values()
	$helpscreen.visible = true

func disabled_buttons() -> void:
	%saddle_set.set_disabled()
	%extras_set.set_disabled()
	%saddles.set_disabled()
	%bridles.set_disabled()
	%blankets.set_disabled()
	%girth_straps.set_disabled()
	%breast_collars.set_disabled()
	%leg_wraps.set_disabled()
	%halters.set_disabled()
	%saddle_bags.set_disabled()
	%armors.set_disabled()
	%pasture_blankets.set_disabled()
	%backButton.set_disabled()
	%full_set.set_disabled()
	%confirmButton.disabled = true

func reenabled_buttons() -> void:
	%saddle_set.reenable_button()
	%extras_set.reenable_button()
	%saddles.reenable_button()
	%bridles.reenable_button()
	%blankets.reenable_button()
	%girth_straps.reenable_button()
	%breast_collars.reenable_button()
	%leg_wraps.reenable_button()
	%halters.reenable_button()
	%saddle_bags.reenable_button()
	%armors.reenable_button()
	%pasture_blankets.reenable_button()
	update_save_button()
	%backButton.reenable_button()
	%full_set.reenable_button()

#################### SCENE MOVING ####################
func _on_back_button_pressed() -> void:
	if not_saved:
		saved_scene = "res://scene/startingGUI.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/startingGUI.tscn")

func on_full_set() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/fullSetCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/fullSetCreation.tscn")

func on_saddle_set() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SaddleSetCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SaddleSetCreation.tscn")

func on_extras_set() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/ExtraSetCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/ExtraSetCreation.tscn")

func on_saddles() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingSaddleCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingSaddleCreation.tscn")

func on_bridles() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingBridleCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingBridleCreation.tscn")

func on_blankets() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingBlanketCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingBlanketCreation.tscn")

func on_girth_straps() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingGirthStrapCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingGirthStrapCreation.tscn")

func on_breast_collars() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingBreastCollarCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingBreastCollarCreation.tscn")

func on_leg_wraps() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingLegWrapsCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingLegWrapsCreation.tscn")

func on_halters() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingHalterCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingHalterCreation.tscn")

func on_saddle_bag() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingSaddleBagCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingSaddleBagCreation.tscn")

func on_armors() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingArmorCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingArmorCreation.tscn")

func on_pasture_blankets() -> void:
	if not_saved:
		saved_scene = "res://scene/tack/SingPasBlanketCreation.tscn"
		not_saved_defaults()
	else:
		get_tree().change_scene_to_file("res://scene/tack/SingPasBlanketCreation.tscn")

#################### SET DEFAULTS ####################
func update_save_button() -> void:
	if not_saved:
		%confirmButton.disabled = false
		%continue.add_theme_color_override("font_color", Color(0.28, 0.46, 0.16))
		%continue.text = "Save Default Values"
	else:
		%confirmButton.disabled = true
		%continue.add_theme_color_override("font_color", Color(0.50, 0.51, 0.36))
		%continue.text = "Default Values Saved"

func _on_saddle_spin_box_value_changed(value: float) -> void:
	saddle = value
	not_saved = true
	update_save_button()

func _on_bridle_spin_box_value_changed(value: float) -> void:
	bridle = value
	not_saved = true
	update_save_button()

func _on_blanket_spin_box_value_changed(value: float) -> void:
	blanket = value
	not_saved = true
	update_save_button()

func _on_halter_spin_box_value_changed(value: float) -> void:
	halter = value
	not_saved = true
	update_save_button()

func _on_leg_wraps_spin_box_value_changed(value: float) -> void:
	leg_wraps = value
	not_saved = true
	update_save_button()

func _on_breast_collar_spin_box_value_changed(value: float) -> void:
	breast_collar = value
	not_saved = true
	update_save_button()

func _on_armor_spin_box_value_changed(value: float) -> void:
	armor = value
	not_saved = true
	update_save_button()

func _on_bag_spin_box_value_changed(value: float) -> void:
	saddle_bag = value
	not_saved = true
	update_save_button()

func _on_girth_strap_spin_box_value_changed(value: float) -> void:
	girth_straps = value
	not_saved = true
	update_save_button()

func _on_pasture_blanket_spin_box_value_changed(value: float) -> void:
	pasture_blanket = value
	not_saved = true
	update_save_button()

func _on_arpasture_blanket_spin_box_value_changed(value: float) -> void:
	ar_pasture_blanket = value
	not_saved = true
	update_save_button()

func _on_confirm_button_pressed() -> void:
	TackScripts.cost_saddle = saddle
	TackScripts.cost_bridle = bridle
	TackScripts.cost_blanket = blanket
	TackScripts.cost_halter = halter
	TackScripts.cost_leg_wraps = leg_wraps
	TackScripts.cost_breast_collar = breast_collar
	TackScripts.cost_armor = armor
	TackScripts.cost_saddle_bag = saddle_bag
	TackScripts.cost_girth_straps = girth_straps
	TackScripts.cost_pasture_blanket = pasture_blanket
	TackScripts.cost_ar_pasture_blanket = ar_pasture_blanket
	not_saved = false
	update_save_button()

func load_values() -> void:
	saddle = TackScripts.cost_saddle
	bridle = TackScripts.cost_bridle
	blanket = TackScripts.cost_blanket
	halter = TackScripts.cost_halter
	leg_wraps = TackScripts.cost_leg_wraps
	breast_collar = TackScripts.cost_breast_collar
	armor = TackScripts.cost_armor
	saddle_bag = TackScripts.cost_saddle_bag
	girth_straps = TackScripts.cost_girth_straps
	pasture_blanket = TackScripts.cost_pasture_blanket
	ar_pasture_blanket = TackScripts.cost_ar_pasture_blanket
	%saddleSpinBox.value = saddle
	%bridleSpinBox.value = bridle
	%blanketSpinBox.value = blanket
	%halterSpinBox.value = halter
	%legWrapsSpinBox.value = leg_wraps
	%breastCollarSpinBox.value = breast_collar
	%armorSpinBox.value = armor
	%bagSpinBox.value = saddle_bag
	%girthStrapSpinBox.value = girth_straps
	%pastureBlanketSpinBox.value = pasture_blanket
	%arpastureBlanketSpinBox.value = ar_pasture_blanket
	not_saved = false
	update_save_button()

func not_saved_defaults() -> void:
	var title = "You have unsaved changes!"
	var message = "You have unsaved default coin values. \nWhat do you want to do?"
	var no_label = "Go Back"
	var yes_label = "Continue"
	$popUP.pop_yesNo(title, message, no_label, yes_label)
	%backButton.disabled = true

func on_popup_back() -> void:
	reenabled_buttons()
	saved_scene = ""

func on_popup_confirmed() -> void:
	get_tree().change_scene_to_file(saved_scene)
	saved_scene = ""
