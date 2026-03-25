extends Node

@export var room_scene: PackedScene
@export var room_size = Vector2(640, 360)
var amountOfRooms = 25
var length = 10
var usedRooms = 0
var map = []
var availablePoints: Array[Vector2i] = []
var rand = RandomNumberGenerator.new()

func _ready():
	rand.randomize()
	init_map()
	startingRoom()
	
	while usedRooms < amountOfRooms:
		getAvailablePoints()
		generateRoom()
	
	print(self)

func init_map():
	for x in range(length):
		map.append([])
		for y in range(length):
			map[x].append(false)
			
func startingRoom():
	@warning_ignore("integer_division")
	map[length/2][length/2] = true
	usedRooms += 1

func getAvailablePoints():
	availablePoints.clear()
	for x in range(length):
		for y in range(length):
			if (map[x][y]):
				if (x != length-1 and  not availablePoints.has(Vector2i(x+1, y)) and not map[x+1][y]):
					availablePoints.append(Vector2i(x+1, y))
				if (x != 0 and  not availablePoints.has(Vector2i(x-1, y)) and not map[x-1][y]):
					availablePoints.append(Vector2i(x-1, y))
				if (y != length-1 and  not availablePoints.has(Vector2i(x, y+1)) and not map[x][y+1]):
					availablePoints.append(Vector2i(x, y+1))
				if (y != 0 and  not availablePoints.has(Vector2i(x, y-1)) and not map[x][y-1]):
					availablePoints.append(Vector2i(x, y-1))

func generateRoom():
	var amount = availablePoints.size()
	var chosen = rand.randi_range(0, amount-1)
	
	var point = availablePoints[chosen]
	map[point.x][point.y] = true
	usedRooms += 1

func _to_string() -> String:
	var result = ""
	for y in range(length):
		for x in range(length):
			result += "X " if map[x][y] else "0 "
		result += "\n"
	return result
	
# After the map is finished
func spawn_actual_rooms():
	for x in range(length):
		for y in range(length):
			if map[x][y]:
				var newRoom = room_scene.instantiate()
				newRoom.position = Vector2(x * room_size.x, y * room_size.y)
				add_child(newRoom)
				var has_n = (y > 0 and map[x][y-1])
				var has_s = (y < length - 1 and map[x][y+1])
				var has_e = (x < length - 1 and map[x+1][y])
				var has_w = (x > 0 and map[x-1][y])
				newRoom.setup_room(Vector2i(x, y), has_n, has_s, has_e, has_w)
	
