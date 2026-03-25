extends Node2D
var canMove = false

var beatMap = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var files = []
var rawbeatmap = []
var oncomingIndex
var rng = RandomNumberGenerator.new()

@onready var beatTimer = get_node("Timer")
var lenghtBetweenBeats
var tolerance

func _ready() -> void:
	get_sounds()
	lenghtBetweenBeats = beatTimer.wait_time
	tolerance = lenghtBetweenBeats/2
	oncomingIndex = 0	
	beatTimer.start()

func _on_timer_timeout() -> void:
	updateIndex()
	decide_tolerance_for_interval()
	if beatMap[oncomingIndex] > 0 :
		canMove = true
		print(tolerance/2)
		playSound()
		await get_tree().create_timer(tolerance).timeout
		canMove = false	
	beatTimer.start()

func isWithinBeatWindow():
	return canMove
	

func _changeRythm(rawbeatmap):	
	for b in rawbeatmap.size():
		if rawbeatmap[b] == 1:
			beatMap[b] = rng.randi_range(1, files.size())
	print (beatMap)



#Timer


#Deciding what to do next beat window
func updateIndex():
	if oncomingIndex == beatMap.size()-1:
		oncomingIndex = 0
	else:
		oncomingIndex += 1

func get_sounds():
	var dir = DirAccess.open("res://Sounds/")
		
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		
		while file != "":
			if not dir.current_is_dir():
				if file.to_lower().ends_with(".wav"):
					files.append(file)
			file = dir.get_next()
		dir.list_dir_end()
	print("Loaded Sound Files")
	print(files)

#Loading sound from directory
func get_nth_sound(n: int):
	if n <= files.size():
		return "res://sounds/" + files[n-1]
	return null

#Playing correct sound
func playSound():
	var sound_path = get_nth_sound(beatMap[oncomingIndex])
	print(sound_path)
	
	if sound_path:
		$Sounds/Drums.stream = load(sound_path)
		$Sounds/Drums.play()
	else:
		$Sounds/Drums.stream = load(get_nth_sound(0))
		$Sounds/Drums.play()

func decide_tolerance_for_interval():
	var size = beatMap.size()
	var distance = 1
	
	while true:
		var index = (oncomingIndex + distance) % size
		
		if beatMap[index] >= 1:
			break
		
		distance += 1
		
		if distance > size:
			tolerance = lenghtBetweenBeats / 2
			return
	
	tolerance = lenghtBetweenBeats * distance / 2

func _on_drums_finished() -> void:
	$Sounds/Drums.stop()
