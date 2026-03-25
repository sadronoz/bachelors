extends Node2D

var grid_pros: Vector2i

func setup_room(coords: Vector2i, n:bool, s:bool, e:bool, w:bool):
	grid_pros = coords
	$North.visible = n
	$South.visible = s
	$East.visible = e
	$West.visible = w
