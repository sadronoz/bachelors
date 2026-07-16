class_name FolderManagement

var titleScreen: Control = null
var sound_folder

func checkFolders():
	var dir = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	if not dir.dir_exists("RhythmGame"):
		createFolders()
	elif not dir.dir_exists("RhythmGame/Sounds") or DirAccess.get_files_at("RhythmGame/Sounds").is_empty():
		insertSounds()
	sound_folder = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/RhythmGame/Sounds"

func createFolders():
	var base_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/RhythmGame"
	insertSounds()
	DirAccess.make_dir_recursive_absolute(base_path + "/Saves")

func insertSounds():
	var source_folder = "res://Sounds"
	var target_folder = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/RhythmGame/Sounds"
	
	DirAccess.make_dir_recursive_absolute(target_folder)
	var files = DirAccess.get_files_at(source_folder)
	
	for file in files:
		var source_path = source_folder + "/" + file
		var target_path = target_folder + "/" + file
		DirAccess.copy_absolute(source_path, target_path)
	print("Sounds copied!")
