extends CharacterBody2D

var tween
@export var vertical_tile_size = 28
@export var horizontal_tile_size = 24
@export var top_side_tile_length = 17

var vertical_step_distance = vertical_tile_size / 2
var horizontal_step_distance = horizontal_tile_size
var time_per_move = 0.3
var steps_to_move = Vector2(0,0)
var current_step = Vector2(0,0)

func _input(event):
	if event.is_action_pressed("move_to"):
		#Assuming zoom.x == zoom.y
		var camera_zoom = $Camera2D.zoom.x
		#Actual in this case refers as to what is displayed on screen
		var actual_h_step = horizontal_step_distance*camera_zoom
		var actual_v_step = vertical_step_distance*camera_zoom
		var actual_top_side = top_side_tile_length*camera_zoom
		
		var horizontal_steps_to_move = 0
		var vertical_steps_to_move = 0
		
		var viewport_center = get_viewport_rect().get_center()
		#The distance from the centre of the character to the cursor is relative cursor position
		var relative_position = event.position - viewport_center
		
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
				
		#Finally correct approximate_vertical_steps so that they up (-1)
		# when they would end up on a line
		if int(horizontal_steps_to_move) % 2 == int(approximate_vertical_steps) % 2:
			vertical_steps_to_move = approximate_vertical_steps
		else:
			vertical_steps_to_move = approximate_vertical_steps - 1
			
		steps_to_move = Vector2(horizontal_steps_to_move, vertical_steps_to_move)

func _process(_delta):
	if !tween || !tween.is_running():
		#Handle keyboard input every frame
		if Input.is_action_pressed("move_down"):
			#When a player is not on a line, request a movement of two steps up
			#So it is possible to move vertically by only pressing once
			if _player_on_line():
				steps_to_move = Vector2(0,1)
			else:
				steps_to_move = Vector2(0,2)
		elif Input.is_action_pressed("move_up"):
			if _player_on_line():
				steps_to_move = Vector2(0,-1)
			else:	
				steps_to_move = Vector2(0,-2)
		elif Input.is_action_pressed("move_left"):
			steps_to_move = Vector2(-1,0)
		elif Input.is_action_pressed("move_right"):
			steps_to_move = Vector2(1,0)
		
		if steps_to_move == Vector2(0,0):
			$AnimatedSprite2D.play("idle")
			if _player_on_line():
				steps_to_move = Vector2(0,1)
		elif steps_to_move.x > 0:
			_move_horizontal(1)
		elif steps_to_move.x < 0:
			_move_horizontal(-1)
		elif steps_to_move.y > 0:
			_move_vertical(1)
		elif steps_to_move.y < 0:
			_move_vertical(-1)

func _move_vertical(direction):
	if direction > 0:
		$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.play("walk_up")
	
	tween = create_tween()
	#The duration of this tween is modified so that moving a tile vertically takes the same amount of time
	#as moving horizontally
	tween.tween_property(self, "position", position + Vector2(0,1) * direction * vertical_step_distance,time_per_move * vertical_step_distance / horizontal_step_distance)
	
	await tween.finished
	steps_to_move -= Vector2(0,direction)
	current_step += Vector2(0, direction)
	
func _move_horizontal(direction):
	$AnimatedSprite2D.play("walk_side")
	$AnimatedSprite2D.flip_h = direction > 0
	
	tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(1,0) * direction * horizontal_step_distance,time_per_move)
	
	await  tween.finished
	steps_to_move -= Vector2(direction,0)
	current_step += Vector2(direction, 0)

func _player_on_line():
	#Player is on a line if there is a mismatch between the parity in vertical and horizontal steps
	#Since a step in any direction will flip this property
	#Hence needs an even number of steps overall
	return abs(int(current_step.x) % 2) != abs(int(current_step.y) % 2)
