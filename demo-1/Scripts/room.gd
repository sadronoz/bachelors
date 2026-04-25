extends Node2D

var grid_pros: Vector2i

func setup_room(coords: Vector2i, n:bool, s:bool, e:bool, w:bool):
	grid_pros = coords
	$North.visible = n
	$South.visible = s
	$East.visible = e
	$West.visible = w
	
	

func transition_player(player, direction):
	# 1. Calculate the neighbor's grid coordinates
	var target_grid_pos = grid_pros
	var entry_marker_name = ""

	if direction == "North": 
		target_grid_pos.y -= 1
		entry_marker_name = "South"
	elif direction == "South":
		target_grid_pos.y += 1
		entry_marker_name = "North"
	elif direction == "East":
		target_grid_pos.x += 1
		entry_marker_name = "West"
	elif direction == "West":
		target_grid_pos.x -= 1
		entry_marker_name = "East"

	# 2. Find the actual Room node in the dungeon
	# This assumes your rooms are all children of the DungeonGenerator
	for room in get_parent().get_children():
		if room is Node2D and room.grid_pros == target_grid_pos:
			# Found the room! Now find the marker inside it
			var marker = room.get_node(entry_marker_name)
			
			# 3. Teleport!
			player.global_position = marker.global_position
			
			# 4. Move Camera
			move_camera(room.global_position)
			break

func move_camera(target_pos):
	var camera = get_viewport().get_camera_2d()
	if camera:
		var tween = create_tween()
		tween.tween_property(camera, "global_position", target_pos, 0.4).set_trans(Tween.TRANS_SINE)
