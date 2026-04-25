extends CharacterBody2D

var speed = 130
var move_time = 0.0
var move_duration = 0.1   # délka pohybu v sekundách
var move_direction = Vector2.ZERO
var hit_this_beat = false

func _physics_process(_delta: float) -> void:
	# most here is for testing purposes
	var player_pos = Singleton.get_player_position()
	move_direction = global_position.direction_to(player_pos)
	
	if Singleton.move_time_enemies > 0:
		#move_time -= delta
		velocity = move_direction * speed
		
		for i in get_slide_collision_count():
			var collision: KinematicCollision2D = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider.is_in_group("player") and not hit_this_beat:
				hit_this_beat = true
				Singleton.remove_hp()
				print("player was hit")
	else:
		hit_this_beat = false
		velocity = Vector2.ZERO
	
	move_and_slide()
