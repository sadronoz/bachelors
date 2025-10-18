extends Node2D
var canMove = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_timer_timeout() -> void:
	canMove = true
	$Sounds/Drums.play()
	await get_tree().create_timer(0.2).timeout
	canMove = false
