extends Camera2D

var horizontal_step_distance
var vertical_step_distance
var top_side_tile_length

func _ready():
	horizontal_step_distance = get_parent().horizontal_step_distance
	vertical_step_distance = get_parent().vertical_step_distance
	top_side_tile_length = get_parent().top_side_tile_length

func get_relative_steps_to_cursor_position(cursor_position):
	#Assuming zoom.x == zoom.y
	var camera_zoom = zoom.x
	#Actual in this case refers as to what is displayed on screen
	var actual_h_step = horizontal_step_distance*camera_zoom
	var actual_v_step = vertical_step_distance*camera_zoom
	var actual_top_side = top_side_tile_length*camera_zoom
	
	var horizontal_steps_to_move = 0
	var vertical_steps_to_move = 0
	
	var viewport_center = get_viewport_rect().get_center()
	#The distance from the centre of the character to the cursor is relative cursor position
	var relative_position = cursor_position - viewport_center
	
	#We can definitely confirm the hexagon the cursor is in
	#if n * actual_h_step - actual_top_side/2 < cursor_x < n * actual_h_step + actual_top_side/2 for some n integer
	# => n < (cursor_x + actual_top_side/2)/(actual_h_step) < n + actual_top_side/h_step
	var x_comparison = (relative_position.x + actual_top_side/2)/(actual_h_step)
	#n above represents an approximation of how many horizontal steps it takes to
	#get to the centre of the hexagon
	var approximate_horizontal_steps = floor(x_comparison)
	var approximate_vertical_steps = floor(relative_position.y/actual_v_step)
	#As by above, if cursor_x satisfies this inequality then it is definitely in
	#the hexagon that takes approximate_horizonal_steps to get to
	if x_comparison < approximate_horizontal_steps + actual_top_side/actual_h_step:
		horizontal_steps_to_move = approximate_horizontal_steps
	else:
		#Now we check whether the cursor is in the hexagon that take approximate_horizontal_steps to
		#get to or in the one after
		#If we draw the hexagons we can see we need to compare whether the cursor
		#lies between two lines one with a positive gradient and one with a negative
		#The positive gradient end up being actual_v_step/(actual_h_step-actual_top_side)
		#since horizontal_length_of_hexagon = 2 * actual_h_step - top_side
		var positive_grad = actual_v_step/(actual_h_step-actual_top_side)
		#The lines are centered at x=(approximate_horizontal_steps+1)*actual_h_step-actual_top_side/2
		#y = approximate_vertical_steps*actual_v_step
		var positive_f = (relative_position.x-(approximate_horizontal_steps+1)*actual_h_step + actual_top_side/2)*positive_grad
		var negative_f = -positive_f
		var comparison_y = relative_position.y - approximate_vertical_steps*actual_v_step
		
		if int(approximate_horizontal_steps) % 2 != int(approximate_vertical_steps) % 2:
			if positive_f < comparison_y && comparison_y < negative_f:
				horizontal_steps_to_move = approximate_horizontal_steps
			else:
				horizontal_steps_to_move = approximate_horizontal_steps + 1
		else:
			if negative_f < comparison_y && comparison_y < positive_f:
				horizontal_steps_to_move = approximate_horizontal_steps + 1
			else:
				horizontal_steps_to_move = approximate_horizontal_steps
			
	#Finally correct approximate_vertical_steps so that they go up (-1)
	# when they would end up on a line
	if int(horizontal_steps_to_move) % 2 == int(approximate_vertical_steps) % 2:
		vertical_steps_to_move = approximate_vertical_steps
	else:
		vertical_steps_to_move = approximate_vertical_steps - 1
		
	return Vector2(horizontal_steps_to_move, vertical_steps_to_move)
