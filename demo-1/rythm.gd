extends Node2D
var canMove = false

var beatMap

var oncomingIndex

@onready var beatTimer = get_node("Timer")
var lenghtBetweenBeats
var tolerance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beatMap = [6,0,0,0,2,0,0,0,3,0,6,0,4,0,8,0,2,0,0,0,2,0,0,0,4,1]
	
	lenghtBetweenBeats = beatTimer.wait_time
	tolerance = lenghtBetweenBeats/2
	oncomingIndex = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	
	if beatMap[oncomingIndex] > 0 :
		canMove = true
		await get_tree().create_timer(tolerance/2).timeout
		playSound()		
		await get_tree().create_timer(tolerance/2).timeout
		
		canMove = false
	updateIndex()
	

func isWithinBeatWindow():
	return canMove

func updateIndex():
	if oncomingIndex == beatMap.size()-1:
		oncomingIndex = 0
	else:
		oncomingIndex += 1

func playSound():
	var sound_path = get_nth_sound(beatMap[oncomingIndex])
	print(sound_path)
	
	if sound_path:
		$Sounds/Drums.stream = load(sound_path)
		$Sounds/Drums.play()
	else:
		$Sounds/Drums.stream = load(get_nth_sound(0))
		$Sounds/Drums.play()
	
	
	#match beatMap[oncomingIndex]:
	#	1:
	#		$Sounds/Drums.play()
	#	2:
	#		pass



func get_nth_sound(n: int):
	var dir = DirAccess.open("res://Sounds/")
	
	if dir:
		var files = []
		
		dir.list_dir_begin()
		var file = dir.get_next()
		
		while file != "":
			if not dir.current_is_dir():
				if file.to_lower().ends_with(".wav"):
					files.append(file)
			file = dir.get_next()
		
		dir.list_dir_end()
		
		if n < files.size():			
			return "res://sounds/" + files[n]
	
	return null


func _on_drums_finished() -> void:
	$Sounds/Drums.stop()
