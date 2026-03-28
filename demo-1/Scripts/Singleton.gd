extends Node

var player: CharacterBody2D = null
var move_time_enemies = 0.0
var move_duration_enemies = 0.1

func _physics_process(delta: float) -> void:
	if move_time_enemies > 0:
		move_time_enemies -= delta

func get_player_position() -> Vector2:
	if player:
		return player.global_position
	return Vector2.ZERO
	
func set_move_time() -> void:
	move_time_enemies = move_duration_enemies
