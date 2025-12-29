extends Node

var directory_root : String = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
#store and start with the desktop directory no matter what system

var root : String = ""
var folder: String = ""
var textures_root : String
var report_file_path : String
var instructions_file_path : String
var commands_file_path : String
var mcmeta_file_path : String
var resourcepackname : String = ""
var description : String = "A SWEM Addendum Coat Resource Pack - Made with Tre's Addendum Pack Helper"

func restart() -> void: #removes all saved values to restart on a new pack
	directory_root = OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	root = ""
	folder = ""
	textures_root = ""
	report_file_path = ""
	instructions_file_path = ""
	commands_file_path = ""
	mcmeta_file_path = ""
	resourcepackname = ""
	description = "A SWEM Addendum Coat Resource Pack - Made with Tre's Addendum Pack Helper"

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

func to_alphanumeric(text : String, force_lower: bool = true, allow_spaces : bool = false): #returns alphanumeric values only
	var temp_n = "" 
	if force_lower:
		text = text.to_lower()
	for char in text:
		if (char >= "a" and char <= "z") or (char >= "0" and char <= "9") or (char >= "A" and char <= "Z"):
			temp_n += char
		elif allow_spaces and char == " ":
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
	report_file_path = join_paths(directory_root, "TRE.S_ADDENDUM_PACK_HELPER_REPORT.txt")
	instructions_file_path = join_paths(directory_root, "INSTRUCTIONS.txt")
	commands_file_path = join_paths(directory_root, "SUMMON_COMMANDS.txt")
	mcmeta_file_path = join_paths(directory_root, "pack.mcmeta")
	DirAccess.make_dir_absolute(directory_root)
	setup_report()
	set_up_instructions()
	set_up_summons()
	set_up_pack_mcmeta("during pack launch")
	textures_root = join_paths(directory_root, "assets")
	make_folder(textures_root)
	textures_root = join_paths(textures_root, resourcepackname)
	make_folder(textures_root)
	report("Finished setting up a new resource pack folder at " + directory_root)

func old_pack_setup(directory : String) -> void: #Open an existing pack
	directory_root = directory
	report_file_path = join_paths(directory_root, "TRE.S_ADDENDUM_PACK_HELPER_REPORT.txt")
	instructions_file_path = join_paths(directory_root, "INSTRUCTIONS.txt")
	commands_file_path = join_paths(directory_root, "SUMMON_COMMANDS.txt")
	mcmeta_file_path = join_paths(directory_root, "pack.mcmeta")
	read_mcmeta()
	setup_report()
	set_up_instructions()
	set_up_summons()
	set_up_pack_mcmeta("during pack launch")
	textures_root = join_paths(directory_root, "assets")
	if !check_folder(textures_root):
		make_folder(textures_root)
	textures_root = join_paths(textures_root, resourcepackname)
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

func make_coat_folder(breed: String) -> void: #see if the breed folder exists - and if it doesn't make it
	var temp_t = join_paths(textures_root, breed)
	if !check_folder(temp_t):
		make_folder(temp_t)

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
				file.store_string("This document will log all creations made by Tre's Addendudmemn Pack Helper application.\n\n" )
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

func set_up_summons() -> void:
	if ErrorManager.is_error:
		return
	else:
		if check_file_exists(commands_file_path):
			var date_time = Time.get_datetime_string_from_system(false, true)
			var file = FileAccess.open(commands_file_path, FileAccess.READ_WRITE)
			file.seek_end()
			file.store_string("\n\n~~~~~~~~~ Pack has been reopened for editing at " + date_time + " ~~~~~~~~~\n")
			file.close()
		else:
			var file = FileAccess.open(commands_file_path, FileAccess.WRITE_READ)
			if !file:
				ErrorManager.is_error = true
				ErrorManager.error_print("Unable to set up the summon commands document - check the file path location.")
				report("Failed to set up the summon commands document when one does not exist at: " + commands_file_path)
				return
			else:
				file.store_string("This document will tell you the commands to summon each of the coats.\n" + \
				"Please understand, your pack will not function if the textures are not correctly named or " + \
				"placed in the wrong folders.\n\n" + \
				"This pack has to remain zipped and put into your resource packs folder and enabled.\n\n")
				file.close()
				report("Set up the SUMMMON_COMMANDS.txt document")

func summon_log(coat_name : String, breed : String):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(commands_file_path, FileAccess.READ_WRITE)
		var coat_string = "~Coat Name: " + coat_name + "\n"
		var breed_string = "~~Breed: " + breed + "\n"
		var command_string = "~~Summon Command: /summon  swemaddendum:" + breed + " ~ ~ ~ {Texture:\"" + resourcepackname + ":" + breed + "/" + coat_name + ".png\"}"
		
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to write a summon command. Please check to see if the folder pathway still exists." )
			return
		else:
			file.seek_end()
			file.store_string("\n")
			file.store_string(coat_string)
			file.store_string(breed_string)
			file.store_string(command_string)
			file.store_string("\n")
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
				"This pack (with the added textures below, and the removal of the above files), needs to be put in the resourcepacks folder.\n\n")
				file.close()
				report("Set up the INSTRUCTIONS.txt document")

func instructions_coat(texture_name : String, path : String, has_wings : bool):
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(instructions_file_path, FileAccess.READ_WRITE)
		var string_1 = "\nADD A NEW COAT TEXTURE\n"# ADD NEW COAT
		var string_2 = "~Coat :" + texture_name + "\n"
		var string_3 = "~~Name the texture: " + texture_name + ".png" + "\n"# ~~Name Texture: kiwi_wonder_pony.png
		var string_4 = "~~Place the texture in: " + path + "\n" # ~~Save to: folder/path/way
		var instruction_string = string_1 + string_2 + string_3 + string_4
		if has_wings:
			string_3 = "~~Name the COAT texture: " + texture_name + ".png" + "\n"# ~~Name Texture: kiwi_wonder_pony.png
			string_4 = "~~Place the textures in: " + path + "\n" # ~~Save to: folder/path/way
			var string_wing = "~~Name the WING texture: " + texture_name + "_wing.png" + "\n"
			instruction_string = string_1 + string_2 + string_3 + string_wing + string_4
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

func set_up_pack_mcmeta(during : String) -> void:
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(mcmeta_file_path, FileAccess.WRITE_READ)
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to write to the pack.mcmeta file - check the file path location.")
			report("Failed to write to the pack.mcmeta file at: " + mcmeta_file_path)
			return
		else:
			file.store_string("{\n")
			file.store_string("  \"pack\": {\n")
			file.store_string("    \"pack_format\": 8,\n")
			file.store_string("    \"description\": \"" + description + "\"\n")
			file.store_string("  }\n")
			file.store_string("}\n")
			file.close()
			report("wrote to the pack.mcmeta file - " + during)

func read_mcmeta() -> void:
	if ErrorManager.is_error:
		return
	else:
		var file = FileAccess.open(mcmeta_file_path, FileAccess.READ)
		if !file:
			ErrorManager.is_error = true
			ErrorManager.error_print("Unable to read the pack.mcmeta file - check the file path location.")
			report("Failed to read the pack.mcmeta file at: " + mcmeta_file_path)
			return
		else:
			var file_data = file.get_as_text()
			file.close()
			# Parse the JSON data using JSON.parse() in Godot 4
			var json = JSON.new()
			var result = json.parse(file_data)
			
			if result == OK:
				var loaded_dict = json.get_data()
				var pack = loaded_dict["pack"]
				description = pack["description"]
			else:
				ErrorManager.is_error = true
				ErrorManager.error_print("Unable to parse the pack.mcmeta file.")
				report("Failed to get the data from the pack.mcmeta file at: " + mcmeta_file_path)
				return


func replace_version_placeholder(textLabel: Label):
	textLabel.text = textLabel.text.replace("$VERSION", ProjectSettings.get_setting("application/config/version"))
