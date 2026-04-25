extends CharacterBody2D

var speed = 130.0
const JUMP_VELOCITY = -300.0
@onready var validator =  get_parent().get_parent().get_node("ActionGate")

@onready var weapon_anchor = $WeaponAnchor
@onready var hitbox_shape = $WeaponAnchor/WeaponHitbox/CollisionShape2D

var move_time = 0.0
var move_duration = 0.1   # délka pohybu v sekundách
var move_direction = Vector2.ZERO
var windowConsumed = false
var maxHP = 3
var currentHP = 3
var attacked = false

func _ready() -> void:
	weapon_anchor.visible = false
	Singleton.player = self

func _physics_process(delta: float) -> void:
	if move_time > 0:
		move_time -= delta
		velocity = move_direction * speed
	else:
		velocity = Vector2.ZERO
		if !attacked:
			attack()
		check_input()
	move_and_slide()

func check_input():
	var direction = get_input_direction()
	if direction != Vector2.ZERO:
		if validator.handlePlayerRequest():
			start_move(direction)

func start_move(direction: Vector2):
	attacked = false
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
	
func attack() -> void:
	attacked = true
	weapon_anchor.visible = true
	var hitbox = $WeaponAnchor/WeaponHitbox

	hitbox_shape.disabled = false
	
	var mouse_pos = get_global_mouse_position()
	var base_angle = (mouse_pos - global_position).angle()
	
	var start_angle = base_angle - deg_to_rad(60)
	var end_angle = base_angle + deg_to_rad(60)
	
	weapon_anchor.rotation = start_angle
	
	hitbox.monitoring = true
	
	var tween = create_tween()
	tween.tween_property(weapon_anchor, "rotation", end_angle, 0.15).set_trans(Tween.TRANS_SINE)
	
	
	tween.finished.connect(func():
		hitbox_shape.disabled = true
		weapon_anchor.rotation = 0
		hitbox.monitoring = false
		weapon_anchor.visible = false
	)
