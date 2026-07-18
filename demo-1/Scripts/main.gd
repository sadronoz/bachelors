extends Control

@onready var grid = $TitleScreen/GridContainer
@onready var title = $TitleScreen

var cells = []
var cell_size = Vector2(25, 50)

var gameInstance
var sound_folder

func _ready():	
	for i in range(25):
		var cell = ColorRect.new()
		cell.custom_minimum_size = cell_size
		if (i%5==0):
			cell.color = Color.PALE_VIOLET_RED
		else:
			cell.color = Color.DARK_GRAY
		
		cell.mouse_filter = Control.MOUSE_FILTER_STOP
		
		cell.gui_input.connect(_on_cell_clicked.bind(cell))
		
		grid.add_child(cell)
		cells.append({
			"index":i,
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
					if (c["index"]%5==0):
						cell.color = Color.PALE_VIOLET_RED
					else:
						cell.color = Color.DARK_GRAY

func _on_start_button_pressed() -> void:
	gameInstance = load("res://Scenes/Game/game.tscn").instantiate()
	add_child(gameInstance)
	
	var rythm = get_tree().get_root().get_node("Main").get_node("Game").get_node("Rythm")
	
	print(rythm)
	var rawbeat = get_beat_array()
	rythm._changeRythm(rawbeat)
	title.hide()

func get_beat_array():
	var beat = []
	for c in cells:
		beat.append(int(c.active))
	return beat
