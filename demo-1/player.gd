extends CharacterBody2D


var speed = 130.0
const JUMP_VELOCITY = -300.0
var canMove = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("Move_left", "Move_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:da
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity = Vector2()
	if Input.is_action_pressed("Move_right"):
		velocity.x += 1
	elif Input.is_action_pressed("Move_left"):
		velocity.x -= 1
	elif Input.is_action_pressed("Move_down"):
		velocity.y += 1
	elif Input.is_action_pressed("Move_up"):
		velocity.y -= 1

	

	match canMove:
		true: 
			if(Input.is_action_pressed("Dash") ):
			#if(Inout.is_action_just_pressed
				velocity = velocity.normalized() * speed
		false:
			velocity = Vector2(0,0)
	move_and_slide()


func _on_timer_timeout() -> void:
	canMove = true
	await get_tree().create_timer(0.2).timeout
	canMove = false
	
