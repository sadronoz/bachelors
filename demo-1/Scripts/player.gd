extends CharacterBody2D


var speed = 130.0
const JUMP_VELOCITY = -300.0
@onready var validator =  get_parent().get_parent().get_node("ActionGate")

var move_time = 0.0
var move_duration = 0.1   # délka pohybu v sekundách
var move_direction = Vector2.ZERO
var windowConsumed = false # TODO possible solution but probably will be removed later
var maxHP = 3
var currentHP = 3

func _ready() -> void:
	Singleton.player = self

func _physics_process(delta: float) -> void:
	if move_time > 0:
		move_time -= delta
		velocity = move_direction * speed
	else:
		velocity = Vector2.ZERO
		check_input()
	move_and_slide()

func check_input():
	var direction = get_input_direction()
	if direction != Vector2.ZERO:
		if validator.handlePlayerRequest():
			start_move(direction)

func start_move(direction: Vector2):
	move_direction = direction
	move_time = move_duration

func get_input_direction() -> Vector2:
	return Input.get_vector("Move_left", "Move_right", "Move_up", "Move_down")

func remove_hp() -> void:
	currentHP -= 1
	if checkHp():
		print("Player died!")
		get_tree().quit()

func checkHp() -> bool:
	if currentHP == 0:
		return true
	else: return false
