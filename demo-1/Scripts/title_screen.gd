extends Control

@onready var grid = $GridContainer

var sound_folder
var gameInstance
var cells = []
var cell_size = Vector2(25, 50)

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
	var folder_manager = FolderManagement.new()
	folder_manager.checkFolders()

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

#New
func _on_button_pressed():	
	gameInstance = load("res://Scenes/Game/game.tscn").instantiate()
	add_child(gameInstance)
	
	var rythm = get_tree().get_root().get_node("TitleScreen").get_node("Game").get_node("Rythm")
	
	print(rythm)
	var rawbeat = get_beat_array()
	rythm._changeRythm(rawbeat)

#Load
func _on_load_button_pressed() -> void:
	pass # Replace with function body.

#Settings
func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

#Quit
func _on_quit_button_pressed() -> void:
	get_tree().quit()
