extends Node

var cost_saddle : int = 16
var cost_bridle : int = 5
var cost_blanket : int = 5
var cost_halter : int = 4
var cost_leg_wraps : int = 4
var cost_breast_collar : int = 10
var cost_armor : int = 64
var cost_saddle_bag : int = 8
var cost_girth_straps : int = 3
var cost_pasture_blanket : int = 16
var cost_ar_pasture_blanket : int = 32

var json_dir : String
var text_dir : String

signal saddle_saved
signal bridle_saved
signal blanket_saved
signal halter_saved
signal leg_wraps_saved
signal breast_collar_saved
signal armor_saved
signal saddle_bag_saved
signal girth_straps_saved
signal pasture_blanket_saved
signal ar_pasture_blanket_saved

func script_start_up() -> void:
	json_dir = GlobalScripts.join_paths(GlobalScripts.jsons_root, "tack")
	text_dir = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")

########## STANDARD SAVE SCRIPTS ##########
func blanket_save(item : String, artist : String, inspo : String, coin : String, adv: bool, preloaded_icon: bool, preloaded_render : bool, preloaded_rack_saddle : bool, preloaded_rack_5 : bool, amount : int = cost_blanket) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "blanket"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Blanket"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_saddle = "rack_saddle_" + java_name + ".png"
		var rack_5 = "rack_blanket_5_" + java_name + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"blanket" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [255, 255, 255],
				"can_wear_armor" = adv
			}
			var rack = {
				"saddle" = root + rack_saddle,
				"blanket_5" = root + rack_5
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			var text_4 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Saddle Blanket Texture: " + leg_texture + "\n" 
			if !preloaded_rack_saddle:
				text_3 = "    Saddle Rack Texture: " + rack_saddle + "\n"
			if !preloaded_rack_5:
				text_4 = "    5 Blanket Rack Texture: " + rack_5 + "\n"
			
			var text_list =  text_1 + text_2 + text_3 + text_4
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render && preloaded_rack_5 && preloaded_rack_saddle:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			blanket_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func saddle_save(item : String, artist : String, inspo : String, coin : String, model : String, adv: bool, preloaded_icon: bool, preloaded_render : bool, preloaded_rack : bool, amount : int = cost_saddle) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "saddle"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Saddle"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_saddle = "rack_saddle_" + java_name + ".png"
		var rack_armor = "rack_horse_armor_" + java_name + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"saddle" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"model_type" = model,
				"can_wear_armor" = adv
			}
			
			var rack = {}
			var text_4 = ""
			if adv:
				rack = {
					"saddle" = root + rack_saddle,
					"horse_armor" = root + rack_armor
				}
				text_4 = "    Horse Armor Rack Texture: " + rack_armor + "\n"
			else:
				rack = {
					"saddle" = root + rack_saddle
				}
				text_4 = ""
			
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Texture: " + leg_texture + "\n" 
			if !preloaded_rack:
				text_3 = "    Saddle Rack Texture: " + rack_saddle + "\n"
			if preloaded_rack && adv:
				text_4 = ""
			
			var text_list =  text_1 + text_2 + text_3 + text_4
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render && preloaded_rack:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			saddle_saved.emit()
			
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func bridle_save(item : String, artist : String, inspo : String, coin : String, model : String, adv: bool, preloaded_icon: bool, preloaded_render_headstall : bool, preloaded_render_reins : bool, preloaded_rack : bool, amount : int = cost_bridle) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "bridle"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Bridle"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_bit_legacy.png"
		var leg_halter_texture = java_name + "_legacy.png"
		var rack_bridle = "rack_bridle_" + java_name + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"bridle" = root + leg_texture,
				"halter" = root + leg_halter_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"model_type" = model,
				"can_wear_armor" = adv
			}
			var rack = {
				"bridle" = root + rack_bridle
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			var text_4 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render_headstall:
				text_2 = "    Horse Bridle Texture: " + leg_halter_texture + "\n" 
			if !preloaded_render_reins:
				text_3 = "    Horse Bit & Reins Texture: " + leg_texture + "\n"
			if !preloaded_rack:
				text_4 = "    Bridle Rack Texture: " + rack_bridle + "\n"
			
			var text_list =  text_1 + text_2 + text_3 + text_4
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render_headstall && preloaded_render_reins && preloaded_rack:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			bridle_saved.emit()
			
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func halter_save(item : String, artist : String, inspo : String, coin : String, adv: bool, preloaded_icon: bool, preloaded_render : bool, preloaded_rack : bool, amount : int = cost_halter) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "halter"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Halter"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_bridle = "rack_halter_lead_" + java_name + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"halter" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [255, 255, 255],
				"can_wear_armor" = adv
			}
			var rack = {
				"halter_lead" = root + rack_bridle
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Halter Texture: " + leg_texture + "\n" 
			if !preloaded_rack:
				text_3 = "    Bridle Rack Texture: " + rack_bridle + "\n"
			
			var text_list =  text_1 + text_2 + text_3 
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render && preloaded_rack:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			halter_saved.emit()
			
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func leg_wraps_save(item : String, artist : String, inspo : String, coin : String, adv: bool, preloaded_icon: bool, preloaded_render_horse : bool, amount : int = cost_leg_wraps) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "leg_wraps"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Leg Wraps"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var leg_hoof_texture = java_name + "_hoof_legacy.png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"leg_wraps" = root + leg_texture,
				"hoof" = root + leg_hoof_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"can_wear_armor" = adv
			}
			var rack = {
				"blanket" = ""
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render_horse:
				text_2 = "    Horse Main Texture: " + leg_texture + "\n" 
				text_3 = "    Horse Hoof Texture: " + leg_hoof_texture + "\n" 
			
			var text_list =  text_1 + text_2 + text_3
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render_horse:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			leg_wraps_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new tack set. The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func breast_collar_save(item : String, artist : String, inspo : String, coin : String, adv: bool, preloaded_icon: bool, preloaded_render : bool, amount : int = cost_breast_collar) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "breast_collar"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Breast Collar"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"breast_collar" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"can_wear_armor" = adv
			}
			var rack = {
				"blanket" = ""
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Breast Collar Texture: " + leg_texture + "\n" 
			
			var text_list =  text_1 + text_2
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			breast_collar_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new tack set. The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func armor_save(item : String, artist : String, inspo : String, coin : String, tier: String, preloaded_icon: bool, preloaded_render_armor : bool, preloaded_render_wings : bool, preloaded_rack : bool, amount : int = cost_armor) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "horse_armor"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Horse Armor"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var leg_wing_texture = java_name + "_wings_legacy.png"
		var rack_armor = "rack_horse_armor_" + java_name + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE_READ)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			var legacy
			if tier != "amethyst":
				legacy = {
					"armor" = root + leg_texture,
					"wings" = ""
				}
			else:
				legacy = {
					"armor" = root + leg_texture,
					"wings" = root + leg_wing_texture
				}
			
			var horse = {"legacy" = legacy}
			var data = {
				"tier" = tier
			}
			var rack = {
				"horse_armor" = root + rack_armor
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			var text_4 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render_armor:
				text_2 = "    Horse Armor Texture: " + leg_texture + "\n" 
			if !preloaded_render_wings && tier == "amethyst":
				text_3 = "    Horse Wings Texture: " + leg_wing_texture + "\n"
			if !preloaded_rack:
				text_4 = "    Armor Rack Texture: " + rack_armor + "\n"
			
			var text_list =  text_1 + text_2 + text_3 + text_4
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render_armor && preloaded_rack && text_3 == "":
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			armor_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func saddle_bag_save(item : String, artist : String, inspo : String, coin : String, preloaded_icon: bool, preloaded_render : bool, amount : int = cost_saddle_bag) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "saddle_bag"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Saddle Bag"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"saddle_bag" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [255, 255, 255]
			}
			var rack = {
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Saddle Bag Texture: " + leg_texture + "\n" 
			
			var text_list =  text_1 + text_2
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			saddle_bag_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new tack set. The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func girth_straps_save(item : String, artist : String, inspo : String, coin : String, adv: bool, preloaded_icon: bool, preloaded_render : bool, preloaded_rack : bool, amount : int = cost_girth_straps) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "girth_strap"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Girth Strap"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_saddle = "rack_saddle_" + java_name + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"girth_strap" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [255, 255, 255],
				"can_wear_armor" = adv
			}
			var rack = {
				"saddle" = root + rack_saddle
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Girth Strap Texture: " + leg_texture + "\n" 
			if !preloaded_rack:
				text_3 = "    Saddle Rack Texture: " + rack_saddle + "\n"
			
			var text_list =  text_1 + text_2 + text_3 
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render && preloaded_rack:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			girth_straps_saved.emit()
			
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func pasture_blanket_save(item : String, artist : String, inspo : String, coin : String, preloaded_icon: bool, preloaded_render : bool, preloaded_rack_short : bool, preloaded_rack_long : bool, amount : int = cost_pasture_blanket) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "pasture_blanket"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Pasture Blanket"
		GlobalScripts.setup_tack(type)
		var original_item = GlobalScripts.text_clean(item)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_short_3 = "rack_pasture_blanket_3_short_" + original_item + ".png"
		var rack_long_5 = "rack_pasture_blanket_5_long_" + original_item + ".png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"pasture_blanket" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [255, 255, 255]
			}
			var rack = {
				"pasture_blanket_long_5" = root + rack_long_5,
				"pasture_blanket_short_3" = root + rack_short_3
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			var text_4 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Pasture Blanket Texture: " + leg_texture + "\n" 
			if !preloaded_rack_long:
				text_3 = "    Long 5 Blanket Texture: " + rack_long_5 + "\n"
			if !preloaded_rack_short:
				text_4 = "    Short 3 Blanket Rack Texture: " + rack_short_3 + "\n"
			
			var text_list =  text_1 + text_2 + text_3 + text_4
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render && preloaded_rack_long && preloaded_rack_short:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			pasture_blanket_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func ar_pasture_blanket_save(item : String, artist : String, inspo : String, coin : String, preloaded_icon: bool, preloaded_render : bool, preloaded_rack_short : bool, preloaded_rack_long : bool, amount : int = cost_ar_pasture_blanket) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "pasture_blanket"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Armored Pasture Blanket"
		GlobalScripts.setup_tack(type)
		var original_item = GlobalScripts.text_clean(item)
		var java_name = item + "_pasture_blanket_armored"
		item = "Armored " + item + " Pasture Blanket"
		java_name = GlobalScripts.text_clean(java_name)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_short_3 = "rack_pasture_blanket_3_short_" + original_item + "_armored.png"
		var rack_long_5 = "rack_pasture_blanket_5_long_" + original_item + "_armored.png"
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"pasture_blanket" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [255, 255, 255],
				"is_armored" = true
			}
			var rack = {
				"pasture_blanket_long_5" = root + rack_long_5,
				"pasture_blanket_short_3" = root + rack_short_3
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			var text_3 = ""
			var text_4 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Armored Pasture Blanket Texture: " + leg_texture + "\n" 
			if !preloaded_rack_long:
				text_3 = "    Long 5 Blanket Texture: " + rack_long_5 + "\n"
			if !preloaded_rack_short:
				text_4 = "    Short 3 Blanket Rack Texture: " + rack_short_3 + "\n"
			
			var text_list =  text_1 + text_2 + text_3 + text_4
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render && preloaded_rack_long && preloaded_rack_short:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			ar_pasture_blanket_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

########## COLORED - NO CUSTOM TEXTURE SAVE SCRIPTS ##########
func colored_blanket_save(rack_5 : Sprite2D, rack_saddle : Sprite2D, item : String, artist : String, inspo : String, coin : String, red : int, green : int , blue : int, adv: bool, preloaded_icon: bool, preloaded_render : bool, amount : int = cost_blanket) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "blanket"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Blanket"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_saddle_text = "rack_saddle_" + java_name + ".png"
		var rack_5_text = "rack_blanket_5_" + java_name + ".png"
		
		var blanket5_path = GlobalScripts.join_paths(text_dir, root + rack_5_text)
		var saddle_path = GlobalScripts.join_paths(text_dir, root + rack_saddle_text)
		if !GlobalScripts.check_file_exists(blanket5_path):
			rack_5.get_texture().get_image().save_png(blanket5_path)
			GlobalScripts.report("Saved new preset 5 Blanket Rack texture - " + blanket5_path)
		if !GlobalScripts.check_file_exists(saddle_path):
			rack_saddle.get_texture().get_image().save_png(saddle_path)
			GlobalScripts.report("Saved new preset Blanket Saddle Rack texture - " + saddle_path)
		
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"blanket" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [red, green, blue],
				"can_wear_armor" = adv
			}
			var rack = {
				"saddle" = root + rack_saddle_text,
				"blanket_5" = root + rack_5_text
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Saddle Blanket Texture: " + leg_texture + "\n" 
			
			var text_list =  text_1 + text_2 
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			blanket_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func colored_girth_strap_save(rack_saddle : Sprite2D, item : String, artist : String, inspo : String, coin : String, red : int, green : int , blue : int, adv: bool, preloaded_icon: bool, preloaded_render : bool, amount : int = cost_girth_straps) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "girth_strap"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Girth Strap"
		GlobalScripts.setup_tack(type)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_saddle_text = "rack_saddle_" + java_name + ".png"
		
		var saddle_path = GlobalScripts.join_paths(text_dir, root + rack_saddle_text)
		if !GlobalScripts.check_file_exists(saddle_path):
			rack_saddle.get_texture().get_image().save_png(saddle_path)
			GlobalScripts.report("Saved new preset Girth Stap Saddle Rack texture - " + saddle_path)
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"girth_strap" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [red, green, blue],
				"can_wear_armor" = adv
			}
			var rack = {
				"saddle" = root + rack_saddle_text
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Girth Strap Texture: " + leg_texture + "\n" 
			
			var text_list =  text_1 + text_2 
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			girth_straps_saved.emit()
			
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func colored_pasture_blanket_save(rack_long : Sprite2D, rack_short : Sprite2D, item : String, artist : String, inspo : String, coin : String, red : int, green : int , blue : int, preloaded_icon: bool, preloaded_render : bool, amount : int = cost_pasture_blanket) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "pasture_blanket"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Pasture Blanket"
		GlobalScripts.setup_tack(type)
		var original_item = GlobalScripts.text_clean(item)
		item = item + " " + type_fancy
		var java_name = GlobalScripts.text_clean(item)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_short_3 = "rack_pasture_blanket_3_short_" + original_item + ".png"
		var rack_long_5 = "rack_pasture_blanket_5_long_" + original_item + ".png"
		
		var long_path = GlobalScripts.join_paths(text_dir, root + rack_long_5)
		var short_path = GlobalScripts.join_paths(text_dir, root + rack_short_3)
		if !GlobalScripts.check_file_exists(long_path):
			rack_long.get_texture().get_image().save_png(long_path)
			GlobalScripts.report("Saved new preset 5 Long Pasture Blanket Rack texture - " + long_path)
		if !GlobalScripts.check_file_exists(short_path):
			rack_short.get_texture().get_image().save_png(short_path)
			GlobalScripts.report("Saved new preset 3 Short Pasture Blanket Rack texture - " + short_path)
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"pasture_blanket" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [red, green, blue]
			}
			var rack = {
				"pasture_blanket_long_5" = root + rack_long_5,
				"pasture_blanket_short_3" = root + rack_short_3
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Pasture Blanket Texture: " + leg_texture + "\n" 
			
			var text_list =  text_1 + text_2 
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			pasture_blanket_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

func colored_ar_pasture_blanket_save(rack_long : Sprite2D, rack_short : Sprite2D, item : String, artist : String, inspo : String, coin : String, red : int, green : int , blue : int, preloaded_icon: bool, preloaded_render : bool, amount : int = cost_ar_pasture_blanket) -> void:
	if ErrorManager.is_error:
		return
	else:
		var type = "pasture_blanket"
		var save_text_path = GlobalScripts.join_paths(GlobalScripts.textures_root, "tack")
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		save_text_path = GlobalScripts.join_paths(save_text_path, type)
		if !GlobalScripts.check_file_exists(save_text_path):
			GlobalScripts.make_folder(save_text_path)
		var type_fancy = "Armored Pasture Blanket"
		GlobalScripts.setup_tack(type)
		var original_item = GlobalScripts.text_clean(item)
		var java_name = item + "_pasture_blanket_armored"
		item = "Armored " + item + " Pasture Blanket"
		java_name = GlobalScripts.text_clean(java_name)
		var file_name = java_name + ".json"
		var path = GlobalScripts.join_paths(json_dir, type)
		path = GlobalScripts.join_paths(path, file_name)
		var root = type + "/"
		var icon = java_name + "_icon.png"
		var leg_texture = java_name + "_legacy.png"
		var rack_short_3 = "rack_pasture_blanket_3_short_" + original_item + "_armored.png"
		var rack_long_5 = "rack_pasture_blanket_5_long_" + original_item + "_armored.png"
		
		var long_path = GlobalScripts.join_paths(text_dir, root + rack_long_5)
		var short_path = GlobalScripts.join_paths(text_dir, root + rack_short_3)
		if !GlobalScripts.check_file_exists(long_path):
			rack_long.get_texture().get_image().save_png(long_path)
			GlobalScripts.report("Saved new preset 5 Long Pasture Blanket Rack texture - " + long_path)
		if !GlobalScripts.check_file_exists(short_path):
			rack_short.get_texture().get_image().save_png(short_path)
			GlobalScripts.report("Saved new preset 3 Short Pasture Blanket Rack texture - " + short_path)
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			var display = {
				"credits" = artist,
				"inspiration" = inspo,
				"name" = item
			}
			
			var cost = {
				"coin" = coin,
				"amount" = amount
			}
			
			var legacy = {
				"pasture_blanket" = root + leg_texture
			}
			var horse = {"legacy" = legacy}
			var data = {
				"color" = [red, green, blue],
				"is_armored" = true
			}
			var rack = {
				"pasture_blanket_long_5" = root + rack_long_5,
				"pasture_blanket_short_3" = root + rack_short_3
			}
			var textures = {"horse" = horse, "rack" = rack}
			
			var meta = {
				"name" = java_name,
				"icon" = root + icon,
				"type" = type,
				"data" = data,
				"textures" = textures,
			}
			
			var save_file = {"display" = display, "cost" = cost, "meta" = meta}
			
			var string_1 = JSON.stringify(save_file, "   ")
			
			file.store_string(string_1)
			file.close()
			
			var text_1 = ""
			var text_2 = ""
			
			if !preloaded_icon:
				text_1 = "    Icon Texture: " + icon + "\n" 
			if !preloaded_render:
				text_2 = "    Horse Armored Pasture Blanket Texture: " + leg_texture + "\n" 
			
			var text_list =  text_1 + text_2 
			var text_path = GlobalScripts.join_paths(text_dir, type)
			
			if preloaded_icon && preloaded_render:
				pass
			else:
				GlobalScripts.instructions_tack(type_fancy, item, text_list, text_path)
			GlobalScripts.report("Saved the new " + type_fancy + ", '" + item + "', to " + path)
			ar_pasture_blanket_saved.emit()
		
		else:
			ErrorManager.error_print("Couldn't save the new " + type_fancy + ". The ./json/tack/" + type + "/ folder wouldn't open. Check to see if it exists.")
			GlobalScripts.report("Failed to save the new " + type_fancy + ", '" + item + "' to " + path)

######### CHECK FOR A DUPLICATE #################
func tack_dupe_check(type : String, item : String):
	var tack_root = ""
	var item_file = ""
	if type == "pasture_blanket_armored":
		tack_root = GlobalScripts.join_paths(json_dir, "pasture_blanket")
		item_file = item + "_pasture_blanket_armored.json"
	else:
		tack_root = GlobalScripts.join_paths(json_dir, type)
		item_file = item + "_" + type + ".json"
	var path = GlobalScripts.join_paths(tack_root, item_file)
	if FileAccess.file_exists(path):
		return true
	else:
		return false
