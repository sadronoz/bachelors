extends Node2D
var canMove = false

var beatMap = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
var files = []
var rawbeatmap = []

var oncomingIndex

#@onready var title = get_parent().get_node("TitleScreen")
@onready var beatTimer = get_node("Timer")

var lenghtBetweenBeats
var tolerance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_sounds()
	lenghtBetweenBeats = beatTimer.wait_time
	tolerance = lenghtBetweenBeats/2
	oncomingIndex = 0	
	beatTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#rawbeatmap is rythm encoded in only 0/1
func _changeRythm(rawbeatmap):
	get_nth_sound(0)
	for b in rawbeatmap.size():
		if rawbeatmap[b] == 1:
			var rng = RandomNumberGenerator.new()
			beatMap[b] = rng.randi_range(1, files.size())

#Check for movement and other actions
func isWithinBeatWindow():
	return canMove

#Timer
func _on_timer_timeout() -> void:
	if beatMap[oncomingIndex] > 0 :
		canMove = true
		await get_tree().create_timer(tolerance/2).timeout
		playSound()
		await get_tree().create_timer(tolerance/2).timeout
		
		canMove = false
	updateIndex()
	beatTimer.start()

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
	if n < files.size():
		return "res://sounds/" + files[n]
	return null

#Playing correct sound
func playSound():
	var sound_path = get_nth_sound(beatMap[oncomingIndex]-1)
	print(sound_path)
	
	if sound_path:
		$Sounds/Drums.stream = load(sound_path)
		$Sounds/Drums.play()
	else:
		$Sounds/Drums.stream = load(get_nth_sound(0))
		$Sounds/Drums.play()

func _on_drums_finished() -> void:
	$Sounds/Drums.stop()
