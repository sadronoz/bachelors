extends Control

@onready var grid = $TitleScreen/GridContainer
@onready var title = $TitleScreen

var sprite_sheet = preload("res://Textures/TitleScreen/Diodes.png")
var inactive_texture : AtlasTexture
var inactive_texture_sec : AtlasTexture
var active_texture : AtlasTexture
var active_texture_sec : AtlasTexture

var cells = []
var cell_size = Vector2(25, 50)

var gameInstance
var sound_folder

func _ready():
	inactive_texture = AtlasTexture.new()
	inactive_texture.atlas = sprite_sheet
	inactive_texture.region = Rect2(0, 0, 8, 10)
	
	inactive_texture_sec = AtlasTexture.new()
	inactive_texture_sec.atlas = sprite_sheet
	inactive_texture_sec.region = Rect2(8, 0, 8, 10)

	active_texture = AtlasTexture.new()
	active_texture.atlas = sprite_sheet
	active_texture.region = Rect2(0, 10, 8, 10)
	
	active_texture_sec = AtlasTexture.new()
	active_texture_sec.atlas = sprite_sheet
	active_texture_sec.region = Rect2(8, 10, 8, 10)
	
	for i in range(25):

		var cell = TextureRect.new()
		cell.custom_minimum_size = cell_size

		if i % 5 == 0:
			cell.texture = inactive_texture_sec
		else:
			cell.texture = inactive_texture

		cell.mouse_filter = Control.MOUSE_FILTER_STOP
		cell.gui_input.connect(_on_cell_clicked.bind(cell))

		grid.add_child(cell)

		cells.append({
			"index": i,
			"node": cell,
			"active": false
		})
	var folder_manager = FolderManagement.new()
	folder_manager.checkFolders()

func _on_cell_clicked(event, cell):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		for c in cells:

			if c.node == cell:

				c.active = !c.active

				if c.active:
					if c.index % 5 == 0:
						cell.texture = active_texture_sec
					else:
						cell.texture = active_texture
				else:
					if c.index % 5 == 0:
						cell.texture = inactive_texture_sec
					else:
						cell.texture = inactive_texture

				break

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
