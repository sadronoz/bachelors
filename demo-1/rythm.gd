extends Node2D
var canMove = false

@onready var beatTimer = get_node("Timer")
var lenghtBetweenBeats
var tolerance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lenghtBetweenBeats = beatTimer.wait_time
	tolerance = lenghtBetweenBeats/5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_timer_timeout() -> void:	
	canMove = true
	await get_tree().create_timer(tolerance/2).timeout
	$Sounds/Drums.play()
	await get_tree().create_timer(tolerance/2).timeout
	canMove = false

func isWithinBeatWindow():
	return canMove
