extends Control

@onready var grid = $GridContainer
var sound_folder

var gameInstance
var cells = []
var cell_size = Vector2(50, 50)

func _ready():	
	for i in range(25):
		var cell = ColorRect.new()
		cell.custom_minimum_size = cell_size
		cell.color = Color.DARK_GRAY
		cell.mouse_filter = Control.MOUSE_FILTER_STOP
		
		cell.gui_input.connect(_on_cell_clicked.bind(cell))
		
		grid.add_child(cell)
		cells.append({
			"node": cell,
			"active": false
		})
	checkFolders()

func _on_cell_clicked(event, cell):
	if event is InputEventMouseButton and event.pressed:
		for c in cells:
			if c.node == cell:
				c.active = !c.active
				
				if c.active:
					cell.color = Color.GREEN
				else:
					cell.color = Color.DARK_GRAY

func get_beat_array():
	var beat = []
	for c in cells:
		beat.append(int(c.active))
	return beat

func _on_button_pressed():	
	gameInstance = load("res://Scenes/Game/game.tscn").instantiate()
	add_child(gameInstance)
	
	var rythm = get_tree().get_root().get_node("TitleScreen").get_node("Game").get_node("Rythm")
	
	print(rythm)
	var rawbeat = get_beat_array()
	rythm._changeRythm(rawbeat)

func checkFolders():
	var dir = DirAccess.open(OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	if not dir.dir_exists("RythmGame"):
		createFolders()
	elif not dir.dir_exists("RythmGame/Sounds") or DirAccess.get_files_at("RythmGame/Sounds").is_empty():
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
