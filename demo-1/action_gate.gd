extends Node2D
@onready var rythm = get_parent().get_node("Rythm")

var onRythm = false
var previousOnRythm = false
var windowConsumed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	previousOnRythm = onRythm
	onRythm = rythm.isWithinBeatWindow()

	# Pokud jsme právě vstoupili do nového okna
	if onRythm and not previousOnRythm:
		windowConsumed = false
		print(windowConsumed)


func handlePlayerRequest():
	if onRythm and not windowConsumed:
		windowConsumed = true
		print(windowConsumed)
		return true
	return false
