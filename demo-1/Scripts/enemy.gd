extends CharacterBody2D

var speed = 130
var move_time = 0.0
var move_duration = 0.1   # délka pohybu v sekundách
var move_direction = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# most here is for testing purposes
	var player_pos = Singleton.get_player_position()
	move_direction = global_position.direction_to(player_pos)
	
	if Singleton.move_time_enemies > 0:
		#move_time -= delta
		velocity = move_direction * speed
	else:
		velocity = Vector2.ZERO
	
	#velocity = move_direction * speed
	move_and_slide() # testing purpose TODO remove once entity moves only once per rythm
