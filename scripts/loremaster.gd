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

var colliding = false


func _input(event):
	if !colliding && event.is_action_pressed("move_to"):
		var relative_steps = $PlayerCamera.get_relative_steps_to_cursor_position(event.position)
		_request_movement(relative_steps.x, relative_steps.y)


func _process(_delta):
	if !colliding && _is_not_moving():
		_process_movement_requests()
		_process_movement()
		
func _process_movement_requests():
	if Input.is_action_pressed("move_down"):
		#When a player is not on a line, request a movement of two steps up
		#So it is possible to move vertically by only pressing once
		if _player_on_line():
			_request_movement(0,1)
		else:
			_request_movement(0,2)
	elif Input.is_action_pressed("move_up"):
		if _player_on_line():
			_request_movement(0,-1)
		else:	
			_request_movement(0,-2)
	elif Input.is_action_pressed("move_left"):
		_request_movement(-1,0)
	elif Input.is_action_pressed("move_right"):
		_request_movement(1,0)
			
#Makes requests for many steps to move that allows movement to later be processed
func _request_movement(step_h, step_v):
	steps_to_move = Vector2(step_h, step_v)
	

func _process_movement():
	if steps_to_move == Vector2(0,0):
		$AnimatedSprite2D.play("idle")
		if _player_on_line():
			_request_movement(0,1)
	elif steps_to_move.x > 0:
		_move_horizontal(1)
	elif steps_to_move.x < 0:
		_move_horizontal(-1)
	elif steps_to_move.y > 0:
		_move_vertical(1)
	elif steps_to_move.y < 0:
		_move_vertical(-1)

#These functions modify steps_to_move to keep player on moving if necessary
func _move_vertical(direction):
	await __move_vertical(direction)
	
	steps_to_move -= Vector2(0,direction)
	
	
func _move_horizontal(direction):
	await __move_horizontal(direction)
	
	steps_to_move -= Vector2(direction,0)
	
#These functions to not adjust steps_to_move as they force movement	
func __move_vertical(direction):
	if direction > 0:
		$AnimatedSprite2D.play("walk_down")
	else:
		$AnimatedSprite2D.play("walk_up")
	
	await _move("vertical", direction)
	
	
func __move_horizontal(direction):
	$AnimatedSprite2D.play("walk_side")
	$AnimatedSprite2D.flip_h = direction > 0
	
	await _move("horizontal", direction)
	
	
func _move(direction: String, magnitude: int):
	var vector_to_move_in_steps
	var vector_to_move_in_position
	var time_to_move
	
	if direction == "horizontal":
		vector_to_move_in_steps = Vector2(1,0) * magnitude
		vector_to_move_in_position = vector_to_move_in_steps * horizontal_step_distance
		time_to_move = time_per_move
	elif direction == "vertical":
		vector_to_move_in_steps = Vector2(0,1) * magnitude
		vector_to_move_in_position = vector_to_move_in_steps * vertical_step_distance
		#The duration of this tween is modified so that moving a tile vertically
		#takes the same amount of time as moving horizontally
		time_to_move = time_per_move * vertical_step_distance / horizontal_step_distance
	
	tween = create_tween()
	tween.tween_property(self, "position", position + vector_to_move_in_position, time_to_move)
	
	await tween.finished
	
	current_step += vector_to_move_in_steps
	
	
func _is_not_moving():
	return !tween || !tween.is_running()
	
	
func _movement_finished():
	await tween.finished


func _player_on_line():
	#Player is on a line if there is a mismatch between the parity in vertical and horizontal steps
	#Since a step in any direction will flip this property
	#Hence needs an even number of steps overall
	return abs(int(current_step.x) % 2) != abs(int(current_step.y) % 2)


func _on_collision(_body):
	colliding = true
	
	var direction_x = sign(steps_to_move.x)
	var direction_y = sign(steps_to_move.y)
	
	await _movement_finished()
	
	steps_to_move = Vector2(0,0)
	if direction_x != 0:
		__move_horizontal(-direction_x)
	elif direction_y != 0:
		__move_vertical(-direction_y)
		
	await _movement_finished()
	
	colliding = false
