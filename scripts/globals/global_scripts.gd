extends Node

var directory_root : String = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
#store and start with the desktop directory no matter what system

var root : String = ""
var folder: String = ""
var artist : String = ""
var jsons_root : String
var textures_root : String
var report_file_path : String
var instructions_file_path : String

func path_clean(path : String): #prepares file paths to proper GDscript format
	var cleaned_path : String
	cleaned_path = path.replace("\\", "/")
	if cleaned_path.ends_with("/"):
		cleaned_path.erase(-1)
	if cleaned_path.begins_with("/"):
		cleaned_path.erase(0)
	return cleaned_path

func text_clean(text : String): #takes strings and makes them acceptable for java
	var temp_n = "" 
	text = text.to_lower()
	for char in text:
		if (char >= "a" and char <= "z") or (char >= "0" and char <= "9") or char == "_":
			temp_n += char
		if char == " " or char == "-":
			temp_n += "_"
		else:
			pass
	if temp_n.begins_with("_"):
		temp_n.erase(0)
	if temp_n.ends_with("_"):
		temp_n.erase(-1)
	return temp_n

func to_alphanumeric(text : String): #returns alphanumeric values only
	var temp_n = "" 
	text = text.to_lower()
	for char in text:
		if (char >= "a" and char <= "z") or (char >= "0" and char <= "9"):
			temp_n += char
		else:
			pass
	return temp_n

func join_paths(root_path : String, folder : String): #joins two values to a correct file path
	var new_path : String
	new_path = root_path + "/" + folder
	return new_path

func new_pack_setup(directory : String) -> void: #Build a new pack
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_PACK_HELPER_REPORT.txt")
	instructions_file_path = join_paths(directory_root, "INSTRUCTIONS.txt")
	jsons_root = join_paths(directory_root, "jsons")
	textures_root = join_paths(directory_root, "textures")
	DirAccess.make_dir_absolute(directory_root)
	setup_report()
	set_up_instructions()
	make_folder(jsons_root)
	make_folder(textures_root)
	report("Finished setting up a new community pack folder at " + directory_root)

func old_pack_setup(directory : String) -> void: #Open an existing pack
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_PACK_HELPER_REPORT.txt")
	instructions_file_path = join_paths(directory_root, "INSTRUCTIONS.txt")
	jsons_root = join_paths(directory_root, "jsons")
	textures_root = join_paths(directory_root, "textures")
	setup_report()
	set_up_instructions()
	if !check_folder(jsons_root):
		make_folder(jsons_root)
	if !check_folder(textures_root):
		make_folder(textures_root)
	report("Completed the opening process for the following folder: " + directory)

func check_folder(path : String): #does a folder exist
	if DirAccess.open(path):
		return true
	else:
		return false

func check_file_exists(path : String): #is there already a file here?
	if FileAccess.file_exists(path):
		return true
	else:
		return false

func make_folder(path : String) -> void: #make a new folder and log it
	DirAccess.make_dir_absolute(path)
	report("Made a new folder at " + path)

func setup_coats() -> void:
	var temp_j = join_paths(jsons_root, "coats")
	var temp_t = join_paths(textures_root, "coats")
	var temp_l = join_paths(temp_t, "legacy")
	if !check_folder(temp_j):
		make_folder(temp_j)
	if !check_folder(temp_t):
		make_folder(temp_t)
	if !check_folder(temp_l):
		make_folder(temp_l)

func setup_tack(tack_type : String):
	var temp_j = join_paths(jsons_root, "tack")
	var temp_t = join_paths(textures_root, "tack")
	var tack_j = join_paths(temp_j, tack_type)
	var tack_t = join_paths(temp_t, tack_type)
	if !check_folder(temp_j):
		make_folder(temp_j)
	if !check_folder(temp_t):
		make_folder(temp_t)
	if !check_folder(tack_j):
		make_folder(tack_j)
	if !check_folder(tack_t):
		make_folder(tack_t)
	
func setup_report() -> void:
	if ErrorManager.is_error:
		return
	else:
		if check_file_exists(report_file_path):
			report("Opened back up this reporting document")
		else:
			var file = FileAccess.open(report_file_path, FileAccess.WRITE_READ)
			if !file:
				ErrorManager.is_error = true
				ErrorManager.error_print("Unable to set up the report document - check the file path location." )
				return
			else:
				file.store_string("This document will log all creations made by Tre's Pack Helper application.\n\n" )
				file.close()
				report("Set up the report document.")

func report(reporting_text : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(report_file_path, FileAccess.READ_WRITE)
		var report_string = Time.get_datetime_string_from_system(false, true) + " -- " + reporting_text + "\n"
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to write a report. Please check to see if the folder pathway still exists." )
			return
		else:
			file.seek_end()
			file.store_string(report_string)
			file.close()

func set_up_instructions() -> void:
	if ErrorManager.is_error:
		return
	else:
		if check_file_exists(instructions_file_path):
			var date_time = Time.get_datetime_string_from_system(false, true)
			var file = FileAccess.open(instructions_file_path, FileAccess.READ_WRITE)
			file.seek_end()
			file.store_string("\n\n~~~~~~~~~ Pack has been reopened for editing at " + date_time + " ~~~~~~~~~\n")
			file.close()
		else:
			var file = FileAccess.open(instructions_file_path, FileAccess.WRITE_READ)
			if !file:
				ErrorManager.is_error = true
				ErrorManager.error_print("Unable to set up the instructions document - check the file path location.")
				report("Failed to set up the instructions document when one does not exist at: " + instructions_file_path)
				return
			else:
				file.store_string("This document will tell you the names of each texture to add and where to add them.\n" + \
				" Please understand, your pack will not function if the textures are not correctly named or placed in the wrong" + \
				" folders.\n Feel free to delete instructions you have completed and copy/paste names and addresses from this document.\n\n" + \
				"This pack (with the added textures below, and the removal of the above files), needs to be put in the config > swem > community-packs folder.\n" + \
				"Please reach out to me (kyraltre) via my discord if you have issues or questions. https://discord.gg/GuYRWK22Mx\n\n")
				file.close()
				report("Set up the INSTRUCTIONS.txt document")

func instructions_coat(texture_name : String, path : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(instructions_file_path, FileAccess.READ_WRITE)
		var string_1 = "\nADD A NEW COAT TEXTURE\n"# ADD NEW COAT
		var string_2 = "~Coat :" + texture_name + "\n"
		var string_3 = "~~Name the texture: " + texture_name + ".png" + "\n"# ~~Name Texture: kiwi_wonder_pony.png
		var string_4 = "~~Place the texture in: " + path + "\n" # ~~Save to: folder/path/way
		var instruction_string = string_1 + string_2 + string_3 + string_4
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to save instructions. Please check to see if the folder pathway still exists." )
			report("Failed on opening the instructions document when saving a coat named: " + texture_name)
			return
		else:
			file.seek_end()
			file.store_string(instruction_string)
			file.close()
			report("Updated the instruction document with information for " + texture_name)

func instructions_tack(type : String, item : String, tack_textures : String , path : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(instructions_file_path, FileAccess.READ_WRITE)
		var string_1 = "\nADD NEW " + type.to_upper() + " TEXTURES\n"# ADD NEW COAT
		var string_2 = "~Tack Piece: " + item + "\n"
		var string_3 = "~~Name the textures as listed below~~\n"# instructions
		var string_4 = "~~Save ALL of these textures in: " + path + "\n" # ~~Save to: folder/path/way
		var instruction_string = string_1 + string_2 + string_3 + tack_textures + string_4
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to save instructions. Please check to see if the folder pathway still exists." )
			report("Failed on opening the instructions document when saving a tack item named: " + item)
			return
		else:
			file.seek_end()
			file.store_string(instruction_string)
			file.close()
			report("Updated the instruction document with information for " + item)


func replace_version_placeholder(textLabel: Label):
	textLabel.text = textLabel.text.replace("$VERSION", ProjectSettings.get_setting("application/config/version"))
