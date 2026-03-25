extends Node2D

var grid_pros: Vector2i

func setup_room(coords: Vector2i, n:bool, s:bool, e:bool, w:bool):
	grid_pros = coords
	$North.visible = n
	$South.visible = s
	$East.visible = e
	$West.visible = w
	
	$North/Area2DNorth/CollisionNorth.disabled = !n
	$South/Area2DSouth/CollisionSouth.disabled = !s
	$East/Area2DEast/CollisionEast.disabled = !e
	$West/Area2DWest/CollisionWest.disabled = !w

func move_camera(target_pos):
	var camera = get_viewport().get_camera_2d()
	if camera:
		var tween = create_tween()
		tween.tween_property(camera, "global_position", target_pos, 0.4).set_trans(Tween.TRANS_SINE)


func _on_area_2d_north_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var target_marker = $North
		
		body.global_position = target_marker.global_position
		
		var next_room_pos = global_position + Vector2(0, -160) 
		move_camera(next_room_pos)


func _on_area_2d_east_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var target_marker = $East
		
		body.global_position = target_marker.global_position
		
		var next_room_pos = global_position + Vector2(288, 0) 
		move_camera(next_room_pos)


func _on_area_2d_west_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var target_marker = $West
		
		body.global_position = target_marker.global_position
		
		var next_room_pos = global_position + Vector2(-288, 0) 
		move_camera(next_room_pos)


func _on_area_2d_south_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var target_marker = $South
		
		body.global_position = target_marker.global_position
		
		var next_room_pos = global_position + Vector2(0, 160) 
		move_camera(next_room_pos)
